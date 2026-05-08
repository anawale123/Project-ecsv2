# ECS v2 — Production AWS Infrastructure

**Python · Go · Docker · Terraform · AWS ECS Fargate · ALB · RDS (PostgreSQL) · ElastiCache (Redis) · SQS · Secrets Manager · KMS · WAF · CodeDeploy · CloudWatch · k6 · GitHub Actions · Cloudflare**

End-to-end design and delivery of production-grade AWS infrastructure for a multi-service URL shortener. The project covers the full delivery lifecycle — from local Docker Compose through to a zero-downtime production deployment with automated rollback and centralised observability, provisioned entirely through Terraform and deployed via an automated CI/CD pipeline.

---

## Services

A multi-language URL shortener with three independently deployed services, all running on ECS Fargate within a shared cluster and backed by a PostgreSQL database.

| Service | Language | Port | Description |
|---------|----------|------|-------------|
| api | Python | 8080 | Shortens URLs, handles redirects, tracks clicks, publishes events to SQS |
| worker | Go | — | Polls SQS for click events, writes analytics to PostgreSQL |
| dashboard | Go | 8081 | Analytics API — top URLs, click stats, hourly breakdowns, recent events |

---

## Documentation

| Document | Covers |
|----------|--------|
| Deployment Lifecycle | Four-phase delivery process — local, dev, staging, and production — including CI/CD pipeline configuration, k6 load test findings, and key infrastructure decisions |
| Architecture README | Full infrastructure reference covering networking, compute, data, autoscaling, blue/green deployment, observability, security, cost decisions, and Terraform module structure |