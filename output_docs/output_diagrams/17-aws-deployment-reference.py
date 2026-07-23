#!/usr/bin/env python3
"""Mesmerize AWS reference deployment — human-readable AWS icons (diagrams).

Render (from repo root):
  python3 -m venv .venv-diagrams && .venv-diagrams/bin/pip install diagrams
  .venv-diagrams/bin/python output_diagrams/17-aws-deployment-reference.py

Requires Graphviz (`dot` on PATH).
Primary human-facing output: 17-aws-deployment-reference.png / .svg
"""

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import ECR, ECS
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.integration import SQS
from diagrams.aws.management import Cloudwatch
from diagrams.aws.network import ALB, CloudFront
from diagrams.aws.security import SecretsManager
from diagrams.aws.storage import S3
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.client import User, Users
from diagrams.onprem.compute import Server
from diagrams.saas.identity import Auth0


def main() -> None:
    graph_attr = {
        "fontsize": "14",
        "bgcolor": "white",
        "pad": "0.5",
        "splines": "spline",
        "nodesep": "0.6",
        "ranksep": "1.0",
        "fontname": "Helvetica",
    }
    node_attr = {"fontsize": "11", "fontname": "Helvetica"}
    edge_attr = {"fontsize": "10", "fontname": "Helvetica"}

    out = "/Users/sasaaleksandrov/mesmerize/output_diagrams/17-aws-deployment-reference"

    with Diagram(
        "Mesmerize — AWS Reference Deployment\n"
        "(Dev / Staging / Prod same shape · zero-PHI on servers · Bridge tenancy default)",
        filename=out,
        outformat=["png", "svg"],
        show=False,
        direction="LR",
        graph_attr=graph_attr,
        node_attr=node_attr,
        edge_attr=edge_attr,
    ):
        with Cluster("People"):
            clinician = Users("Clinicians\n(Athena SMART)")
            devices = User("Clinic devices\n(Esper PWA)")
            admin = User("Admins\n(Command Center)")

        with Cluster("External (outside VPC)"):
            athena = Server("athenahealth\nSMART / FHIR")
            auth0 = Auth0("Auth0")
            esper = Server("Esper MDM")
            cms = Server("Sanity /\nBioDigital / MJH")

        with Cluster("Edge"):
            cf = CloudFront("CloudFront\nSMART + media")
            alb = ALB("ALB HTTPS\n(+ Socket.io sticky)")

        with Cluster("ECS Fargate (multi-AZ)\nlogical services; may co-locate in pilot"):
            api = ECS("API services\nsession · content · org\nbilling · engagement · ads")
            realtime = ECS("device-realtime\nSocket.io")
            workers = ECS("Workers\naudit · SQS consumers")

        with Cluster("Data & messaging (private)"):
            rds = RDS("RDS PostgreSQL 16\nBridge + tenantId\n(Silo DBs optional)")
            redis = ElastiCache("ElastiCache Redis 7")
            s3 = S3("S3\n{tenantId}/{clinicId}/…")
            sqs = SQS("SQS\nreq / reply / events\n+ DLQ")

        secrets = SecretsManager("Secrets Manager\n+ IAM task roles")
        monitor = Cloudwatch("Observability\n(Datadog / approved)")

        with Cluster("CI/CD"):
            gha = GithubActions("GitHub Actions")
            ecr = ECR("ECR")

        clinician >> Edge(label="EHR launch") >> athena
        athena >> Edge(label="iframe") >> cf
        clinician >> cf
        devices >> Edge(label="HTTPS / WS") >> alb
        admin >> auth0
        admin >> alb

        cf >> alb
        alb >> api
        alb >> realtime

        api >> rds
        api >> sqs
        realtime >> redis
        realtime >> rds
        realtime >> sqs
        workers >> sqs
        workers >> rds
        api >> s3
        workers >> s3

        api >> cms
        realtime >> esper
        api >> auth0

        secrets >> api
        secrets >> realtime
        monitor >> api
        monitor >> workers

        gha >> ecr
        ecr >> api
        ecr >> realtime
        ecr >> workers


if __name__ == "__main__":
    main()
