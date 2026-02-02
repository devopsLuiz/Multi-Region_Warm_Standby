# 🚀 Multi-Region Warm Standby Architecture on AWS

## 📌 Overview

Este projeto é um **case de arquitetura cloud multi-region**, projetado seguindo a estratégia de **Warm Standby**, com foco em **resiliência, alta disponibilidade e decisões arquiteturais realistas**.

O sistema simula um produto online que precisa continuar operando mesmo diante de falhas regionais, equilibrando **disponibilidade, custo e complexidade operacional**.

> O objetivo **não é escala massiva**, mas demonstrar **pensamento de produção**, **trade-offs conscientes** e **maturidade em infraestrutura cloud**.

---

## 🌡️ O que é Warm Standby?

**Warm Standby** é uma estratégia de disaster recovery onde:

- A **região primária** recebe todo o tráfego
- A **região secundária** já possui infraestrutura ativa
- A capacidade na região secundária é **reduzida**
- Em caso de falha, ocorre **failover controlado**

### Por que Warm Standby?

- Menor custo que Active-Active
- Menor complexidade operacional
- Recuperação mais rápida que Pilot Light
- Ideal para produtos em crescimento ou workloads críticos não-massivos

👉 Esta arquitetura foi **intencionalmente desenhada como Warm Standby**, evitando overengineering.

---

## 🎯 Objetivos do Projeto

- Implementar uma arquitetura **multi-region Warm Standby**
- Garantir **alta disponibilidade regional**
- Utilizar **Infraestrutura como Código (Terraform)**
- Demonstrar estratégias reais de **failover**
- Manter **custo sob controle**
- Evidenciar **mentalidade DevOps / SRE**

---

## 🧩 Arquitetura – Visão Geral

**Principais componentes:**

- Amazon **ECS (EC2 launch type)** em duas regiões
- **Application Load Balancer (ALB)** por região
- **CloudFront** como entry point global
- **Aurora Global Database** (writer + read replica cross-region)
- **S3 + CloudFront** para frontend estático
- **IAM e Security Groups** com princípio de menor privilégio
- **Terraform** para provisionamento completo

---

## 🗺️ Diagrama básico da Arquitetura (Warm Standby)



                      +------------------+
                      |      Users       |
                      +---------+--------+
                                |
                         +------+------+
                         |  CloudFront |
                         |   (Global)  |
                         +------+------+
                                |
              +-----------------+-----------------+
              |                                   |
    +---------+---------+               +---------+---------+
    |  Region A (Primary)|               | Region B (Standby)|
    |                    |               |                    |
    |  +--------------+  |               |  +--------------+  |
    |  |     ALB      |  |               |  |     ALB      |  |
    |  +------+-------+  |               |  +------+-------+  |
    |         |          |               |         |          |
    |  +------+-------+  |               |  +------+-------+  |
    |  | ECS Cluster  |  |               |  | ECS Cluster  |  |
    |  |   (EC2)      |  |               |  |   (EC2)      |  |
    |  +------+-------+  |               |  +------+-------+  |
    |         |          |               |         |          |
    |  +------+-------+  |   Replication |  +------+-------+  |
    |  | Aurora Writer|<---------------->|  | Aurora Reader|  |
    |  +--------------+  |               |  +--------------+  |
    +--------------------+               +--------------------+


---

## 🌍 Estratégia Multi-Region (Warm Standby)

| Camada | Região Primária | Região Secundária |
|-----|----------------|------------------|
| CloudFront | Ativo | Ativo |
| ALB | Ativo | Ativo |
| ECS | Ativo | Ativo (menor scale) |
| Banco de Dados | Writer | Read Replica |
| Tráfego | 100% | Standby |

💡 **Failover envolve:**
- Promoção do banco secundário
- Escala do ECS
- Ajuste de roteamento (CloudFront / Route 53)

---

## 🛠️ Por que ECS EC2 e não Fargate?

| ECS EC2 | Fargate |
|------|------|
| Maior controle | Menos gestão |
| Melhor previsibilidade de custo | Mais caro |
| Capacity Providers | Simplicidade |

👉 Escolha feita para **controle, aprendizado e visibilidade operacional**.

---

## 🔁 Estratégia de Deploy

- **Rolling Update** via ECS Service
- Imagens versionadas no **Amazon ECR**
- Deploy sem downtime
- Deploy desacoplado de DNS

---

## 🧪 Resiliência & Cenários de Falha

| Cenário | Comportamento |
|------|-------------|
| Falha de container | ECS recria task |
| Falha de EC2 | ASG substitui instância |
| Falha de AZ | ALB redistribui tráfego |
| Falha de região | Failover planejado |
| Falha do DB writer | Promoção manual |

---

## 💰 Considerações de Custo

Este projeto **não roda 24/7**.

Decisões conscientes:
- ECS EC2 ao invés de Fargate
- Capacidade reduzida na região standby
- Infra ligada apenas para testes e demos

> Custo é parte da engenharia, não pós-pensamento.

---

## 🧠 Trade-offs Assumidos

- Failover de escrita não é automático
- Consistência eventual aceita
- Active-Active evitado propositalmente
- Cell-based architecture considerada excessiva para o contexto

---

## 🛣️ Próximos Passos

- Route 53 com health checks e failover DNS
- Automação do failover do Aurora
- Chaos Engineering
- Blue/Green no ECS
- Observabilidade avançada

---

## 📚 Principais Aprendizados

- Multi-region ≠ Active-Active
- Warm Standby é um excelente equilíbrio
- Infra resiliente exige decisões conscientes
- IaC é essencial para recuperação e auditoria

---

## 📎 Disclaimer

Este é um **projeto de portfolio**, com foco educacional e arquitetural.  
Não representa um ambiente produtivo de alto tráfego.
