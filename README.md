Enterprise Azure AKS Platform Infrastructure
Project Overview

This Terraform project provisions a complete enterprise-grade Azure Kubernetes Service (AKS) platform using a modular Infrastructure as Code approach.

The platform is designed to host containerized enterprise applications such as:

React Frontend
Spring Boot Backend
PostgreSQL Database

The infrastructure is deployed through Azure DevOps pipelines using Terraform modules.

The design focuses on:

Scalability
Security
Automation
Reusability
High Availability
Centralized Monitoring
High Level Architecture
Internet Users
      |
      v
Azure Front Door
      |
      v
Front Door WAF
      |
      v
Application Gateway
      |
      v
Application Gateway WAF
      |
      v
AGIC
      |
      v
Azure Kubernetes Service

     AKS
      |
      +------------------+
      |                  |
      v                  v

React Frontend     Spring Boot API
                          |
                          |
                          v

               PostgreSQL Flexible Server

Supporting Services

Azure Container Registry
Azure Key Vault
Managed Identity
Private Endpoints
Log Analytics
Application Insights

Terraform Repository Structure
terraform
│
├── environments
│   └── prod
│       ├── backend.tf
│       ├── provider.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
└── modules
    ├── resource-group
    ├── networking
    ├── acr
    ├── keyvault
    ├── managed-identity
    ├── monitoring
    ├── appgateway
    ├── frontdoor
    ├── postgresql
    ├── aks
    ├── role-assignment
    └── private-endpoints

Modular Design Approach

The project follows a modular Terraform architecture.

Every Azure service is created in its own module.

Example:

AKS logic
    →
modules/aks

ACR logic
    →
modules/acr

Key Vault logic
    →
modules/keyvault


Benefits:

Reusable
Easier maintenance
Easier upgrades
Environment independent
Consistent configuration
Deployment Flow

Terraform deployment begins from:

terraform/environments/prod/main.tf


This file orchestrates all infrastructure modules.

Deployment flow:

Resource Group
      |
      v
Networking
      |
      v
ACR
      |
      v
Monitoring
      |
      v
Key Vault
      |
      v
Managed Identity
      |
      v
Application Gateway + WAF
      |
      v
PostgreSQL
      |
      v
AKS
      |
      v
RBAC Assignments
      |
      v
Private Endpoints
      |
      v
Front Door

Resource Group
Service Used
Azure Resource Group


Created Resource:

rg-prod-aks-app

Purpose

Acts as the logical container for all Azure resources.

All infrastructure resources are deployed inside this resource group.

Examples:

AKS
ACR
Key Vault
Application Gateway
Front Door
PostgreSQL
Monitoring

Networking
Service Used
Azure Virtual Network
Azure Subnets


Created Resources:

vnet-prod-aks-app

aks-subnet

appgw-subnet

postgresql-subnet

private-endpoint-subnet

Purpose

Provides private communication between Azure services.

AKS Subnet

Purpose:

Hosts:

AKS Nodes
AKS Pods

Application Gateway Subnet

Purpose:

Hosts:

Azure Application Gateway


Application Gateway requires a dedicated subnet.

PostgreSQL Subnet

Purpose:

Hosts:

Azure PostgreSQL Flexible Server


Configured as delegated subnet.

Private Endpoint Subnet

Purpose:

Hosts:

ACR Private Endpoint
Key Vault Private Endpoint

Azure Container Registry (ACR)
Service Used
Azure Container Registry


Created Resource:

acrprodaksapp001

Purpose

Stores Docker images.

Example:

React Frontend Image

Spring Boot Backend Image

Flow
Developer Code
        |
        v

Azure DevOps Pipeline
        |
        v

Docker Build
        |
        v

Push To ACR
        |
        v

AKS Pulls Images

Key Vault
Service Used
Azure Key Vault


Created Resource:

kv-prod-aks-app01

Purpose

Stores:

Passwords

Connection Strings

Secrets

Certificates

Use Case

Instead of storing credentials in code:

Application
      |
      v
Key Vault
      |
      v
Secret Retrieval

Managed Identity
Service Used
Azure User Assigned Managed Identity


Created Resource:

mi-prod-aks-app

Purpose

Provides secure authentication between Azure services.

Eliminates:

Hardcoded Passwords

Client Secrets

Service Principal Secrets

Monitoring
Service Used
Log Analytics Workspace

Application Insights


Resources:

law-prod-aks-app

appi-prod-aks-app

Purpose

Provides centralized monitoring.

Collects:

AKS Logs

Container Logs

Application Logs

Performance Metrics

Node Metrics

Application Gateway
Service Used
Azure Application Gateway


Created Resource:

agw-prod-aks-app

Purpose

Acts as Layer 7 Load Balancer.

Provides:

URL Routing

SSL Termination

Health Probes

Traffic Distribution

WAF Policy
Service Used
Azure Web Application Firewall


Created Resource:

waf-prod-aks-app

Purpose

Protects applications from:

SQL Injection

Cross Site Scripting

OWASP Top 10


Mode:

Prevention

Application Gateway Ingress Controller (AGIC)
Service Used
AGIC AKS Add-on


Purpose:

Connects:

AKS
      ↔
Application Gateway

How It Works

AGIC watches:

Ingress Resources


inside AKS.

When changes occur:

Ingress Updated
        |
        v

AGIC Detects Change
        |
        v

Application Gateway Updated


Automatically creates:

Listeners

Backend Pools

Routing Rules

Health Probes

PostgreSQL Flexible Server
Service Used
Azure PostgreSQL Flexible Server


Created Resources:

psql-prod-aks-app

Database:
appdb

Purpose

Stores application data.

Used by:

Spring Boot Backend

Flow
Frontend
     |
     v

Backend API
     |
     v

PostgreSQL Database

AKS Cluster
Service Used
Azure Kubernetes Service


Created Cluster:

aks-prod-app

System Node Pool

Purpose:

Runs Kubernetes system workloads.

Examples:

CoreDNS

Metrics Server

CSI Drivers

AKS Components


VM Size:

Standard_D2s_v5

Frontend Node Pool

Purpose:

Runs application workloads.

Examples:

React Pods

Spring Boot Pods


VM Size:

Standard_D2s_v5

Backend Node Pool

Purpose:

Dedicated node pool for backend workloads.

Benefits:

Workload Isolation

Independent Scaling

Improved Performance


VM Size:

Standard_D2s_v5

Front Door
Service Used
Azure Front Door

Purpose

Provides:

Global Entry Point

Global Load Balancing

Edge Security

Performance Optimization

Traffic Flow
Internet
      |
      v

Azure Front Door
      |
      v

Application Gateway
      |
      v

AKS

Private Endpoints
Services Used
Azure Private Endpoint


Resources:

ACR Private Endpoint

Key Vault Private Endpoint

Purpose

Provides private network communication.

Traffic stays inside Azure backbone.

No public exposure.

Role Assignments
Service Used
Azure RBAC


Implemented through:

modules/role-assignment

Purpose

Provide least privilege access.

Examples:

AKS → ACR
AcrPull


Allows AKS to pull images.

AKS → Key Vault
Key Vault Secrets User


Allows workloads to read secrets.

AGIC → Application Gateway
Contributor

Reader

Network Contributor


Allows AGIC to manage Application Gateway configuration.

Infrastructure Security Flow
Managed Identity
        |
        v

Azure RBAC
        |
        v

Key Vault
        |
        v

AKS Workloads


Security layers:

Front Door WAF

Application Gateway WAF

Private Endpoints

Managed Identity

RBAC

Key Vault

Complete Application Request Flow
User Request
      |
      v

Azure Front Door

      |
      v

Front Door WAF

      |
      v

Application Gateway

      |
      v

Application Gateway WAF

      |
      v

AGIC

      |
      v

AKS Ingress

      |
      v

React Frontend Pod

      |
      v

Spring Boot Backend Pod

      |
      v

PostgreSQL Flexible Server

Summary

This Terraform platform provisions a complete enterprise-grade Azure application hosting platform that provides:

Infrastructure as Code
Modular Terraform Design
AKS-Based Application Hosting
Application Gateway Integration
Front Door Global Routing
WAF Protection
Managed Identity Authentication
Private Connectivity
Centralized Monitoring
Secure Secret Management
Azure DevOps Automation

The design follows reusable module architecture, allowing the same Terraform modules to be reused across Development, QA, UAT, and Production environments with minimal configuration changes.