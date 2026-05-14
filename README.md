# Power Migration Lab - Terraform Infrastructure

## Objetivo

Este projeto Terraform provisiona a infraestrutura base para um sandbox de migração AIX on POWER para IBM Power Virtual Server.

**Importante**: Este projeto cria **apenas a infraestrutura**. Toda automação dentro do sistema operacional AIX/Linux (mksysb, savevg, restvg, configuração de volume groups, filesystems, etc.) deve ser feita posteriormente via Ansible.

## Arquitetura do Sandbox

O laboratório provisiona os seguintes componentes na IBM Cloud:

```
IBM Cloud
├── Resource Group dedicado
├── VPC Sandbox
│   ├── Subnet
│   ├── Security Group
│   └── Linux VSI Bastion/Staging
├── IBM Cloud Object Storage
│   └── Bucket para artefatos de migração
└── PowerVS Workspace
    ├── Rede privada PowerVS
    ├── AIX-SRC-01 (source)
    │   ├── rootvg
    │   └── volume adicional para simular datavg/appvg
    ├── AIX-DST-01 (target)
    │   ├── rootvg
    │   └── volume adicional para restore de datavg/appvg
    └── Opcional: AIX-NIM-01 (NIM server)
```

Para mais detalhes sobre a arquitetura, consulte [docs/architecture.md](docs/architecture.md).

## Pré-requisitos

### Conta IBM Cloud

- Conta IBM Cloud ativa
- Permissões necessárias para:
  - IBM Power Virtual Server
  - VPC Infrastructure
  - Cloud Object Storage
  - Virtual Server Instances
  - Resource Groups

### Ferramentas

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- IBM Cloud CLI (opcional, para validação)
- Par de chaves SSH

### Permissões Necessárias

Ao executar no IBM Cloud Schematics, o workspace deve ter as seguintes permissões:

- **Power Systems Virtual Server**: Editor ou Administrator
- **VPC Infrastructure Services**: Editor ou Administrator
- **Cloud Object Storage**: Editor ou Administrator
- **Resource Group**: Viewer (mínimo) ou Editor (se criar novo)

**Nota**: Quando executado no Schematics, a autenticação é gerenciada automaticamente pelo workspace.

## Configuração

### 1. Clone o Repositório

```bash
git clone <repository-url>
cd power-migration-lab
```

### 2. Configure as Variáveis

Copie o arquivo de exemplo e edite com seus valores:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edite `terraform.tfvars` com seus valores específicos:

```hcl
# General Configuration
region               = "us-south"
zone                 = "us-south-1"
resource_group_name  = "power-migration-lab"
create_resource_group = true
prefix               = "pml"
tags                 = ["power-migration", "sandbox", "terraform"]

# SSH Configuration
ssh_public_key    = "ssh-rsa AAAAB3NzaC1yc2E... your-email@example.com"
allowed_ssh_cidr  = "0.0.0.0/0"  # Restrinja para seu IP em produção

# PowerVS Configuration
powervs_datacenter = "dal12"
powervs_zone       = "us-south"
aix_image_name     = "7300-02-01"  # Verifique imagens disponíveis no seu datacenter

# AIX Instances Configuration
aix_source_processors = "0.5"
aix_source_memory     = "4"
aix_target_processors = "0.5"
aix_target_memory     = "4"

# Optional NIM Server
create_nim = false
```

Para lista completa de variáveis e suas descrições, consulte [docs/variables.md](docs/variables.md).

### 3. Gere um Par de Chaves SSH (se necessário)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/power_migration_lab -C "power-migration-lab"
```

Use o conteúdo de `~/.ssh/power_migration_lab.pub` na variável `ssh_public_key`.

## Uso

### Executando no IBM Cloud Schematics (Recomendado)

Este projeto está configurado para ser executado no IBM Cloud Schematics, que gerencia automaticamente a autenticação:

1. Acesse o IBM Cloud Schematics
2. Crie um novo workspace
3. Aponte para este repositório
4. Configure as variáveis necessárias (exceto `ibmcloud_api_key`)
5. Execute o plano e aplique

### Executando Localmente

Se executar localmente, você precisará configurar a autenticação via:
- Variável de ambiente `IC_API_KEY`
- IBM Cloud CLI (`ibmcloud login`)

#### Inicializar Terraform

```bash
terraform init
```

### Formatar e Validar

```bash
terraform fmt -recursive
terraform validate
```

### Planejar a Infraestrutura

```bash
terraform plan -var-file="terraform.tfvars"
```

Revise cuidadosamente o plano antes de aplicar.

### Aplicar a Infraestrutura

```bash
terraform apply -var-file="terraform.tfvars"
```

Digite `yes` quando solicitado para confirmar.

### Exportar Outputs

Após a aplicação bem-sucedida, exporte os outputs para uso posterior:

```bash
terraform output -json > tf_outputs.json
```

Este arquivo JSON pode ser usado para gerar inventários Ansible automaticamente.

### Visualizar Outputs Específicos

```bash
# Ver todos os outputs
terraform output

# Ver output específico
terraform output bastion_public_ip
terraform output ansible_inventory
```

## Outputs

Os principais outputs incluem:

- **Resource Group ID**: ID do resource group criado/usado
- **COS Instance ID**: ID da instância Cloud Object Storage
- **COS Bucket Name**: Nome do bucket para artefatos
- **VPC ID**: ID da VPC criada
- **Bastion Public IP**: IP público do bastion para acesso SSH
- **Bastion Private IP**: IP privado do bastion
- **PowerVS Workspace ID**: ID do workspace PowerVS
- **AIX Source IP**: IP privado da instância AIX source
- **AIX Target IP**: IP privado da instância AIX target
- **AIX NIM IP**: IP privado da instância NIM (se criada)
- **Ansible Inventory**: Mapa JSON com dados para inventário Ansible

Para lista completa de outputs, consulte [docs/outputs.md](docs/outputs.md).

## Destruir a Infraestrutura

**Atenção**: Este comando remove TODOS os recursos criados. Use com cuidado!

```bash
terraform destroy -var-file="terraform.tfvars"
```

Digite `yes` quando solicitado para confirmar.

## Estrutura do Projeto

```
.
├── README.md                          # Este arquivo
├── versions.tf                        # Versões do Terraform e providers
├── providers.tf                       # Configuração dos providers
├── variables.tf                       # Declaração de variáveis
├── terraform.tfvars.example           # Exemplo de valores para variáveis
├── main.tf                            # Chamadas aos módulos
├── outputs.tf                         # Outputs do projeto
├── locals.tf                          # Variáveis locais
├── .gitignore                         # Arquivos ignorados pelo Git
├── modules/                           # Módulos Terraform
│   ├── resource_group/                # Módulo para Resource Group
│   ├── cos/                           # Módulo para Cloud Object Storage
│   ├── vpc/                           # Módulo para VPC e rede
│   ├── bastion/                       # Módulo para VSI Bastion
│   └── powervs/                       # Módulo para PowerVS e AIX instances
└── docs/                              # Documentação adicional
    ├── architecture.md                # Arquitetura detalhada
    ├── variables.md                   # Documentação de variáveis
    ├── outputs.md                     # Documentação de outputs
    └── sandbox-vs-real-environment.md # Diferenças sandbox vs produção
```

## Limitações

Este projeto Terraform tem as seguintes limitações intencionais:

- ❌ **Não executa** automação dentro do sistema operacional AIX
- ❌ **Não executa** mksysb, savevg, restvg
- ❌ **Não configura** volume groups ou filesystems
- ❌ **Não realiza** migração ou restore de dados
- ❌ **Não executa** cutover ou validações de aplicação
- ✅ **Apenas cria** a infraestrutura base necessária

Para entender as diferenças entre este sandbox e um ambiente real de migração, consulte [docs/sandbox-vs-real-environment.md](docs/sandbox-vs-real-environment.md).

## Próximos Passos

Após provisionar a infraestrutura com este projeto Terraform:

1. **Validar Conectividade**
   ```bash
   # Conectar ao bastion
   ssh -i ~/.ssh/power_migration_lab root@<bastion_public_ip>
   
   # Do bastion, conectar às instâncias AIX
   ssh root@<aix_source_private_ip>
   ssh root@<aix_target_private_ip>
   ```

2. **Preparar Inventário Ansible**
   - Use o output `ansible_inventory` para gerar seu inventário
   - Configure variáveis específicas do Ansible

3. **Executar Playbooks Ansible**
   - Configurar volume groups e filesystems
   - Gerar mksysb/savevg no source
   - Transferir artefatos para COS
   - Restaurar no target
   - Validar migração

4. **Documentar Resultados**
   - Tempos de backup/restore
   - Tamanho dos artefatos
   - Lições aprendidas

## Troubleshooting

### Erro: "No valid credential sources found"

**No Schematics**: Verifique se o workspace tem as permissões corretas configuradas.

**Localmente**: Configure a autenticação via:
```bash
export IC_API_KEY="your-api-key"
# ou
ibmcloud login
```

### Erro: "Image not found" no PowerVS

As imagens AIX disponíveis variam por datacenter. Liste as imagens disponíveis:

```bash
ibmcloud pi images --json
```

Atualize a variável `aix_image_name` com uma imagem válida.

### Erro: "Insufficient quota"

Verifique suas quotas na IBM Cloud:
- PowerVS: Processadores e memória
- VPC: VSIs e floating IPs
- COS: Instâncias e storage

### Timeout ao criar PowerVS instances

Instâncias PowerVS podem levar 10-20 minutos para provisionar. Se houver timeout:
- Verifique o status no console IBM Cloud
- Aumente o timeout no módulo PowerVS se necessário

## Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto é fornecido como exemplo educacional para laboratórios de migração AIX para PowerVS.

## Suporte

Para questões sobre:
- **IBM Cloud**: Consulte a [documentação oficial](https://cloud.ibm.com/docs)
- **Power Virtual Server**: Consulte a [documentação PowerVS](https://cloud.ibm.com/docs/power-iaas)
- **Terraform IBM Provider**: Consulte o [registry](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs)

## Referências

- [IBM Power Virtual Server Documentation](https://cloud.ibm.com/docs/power-iaas)
- [IBM Cloud VPC Documentation](https://cloud.ibm.com/docs/vpc)
- [IBM Cloud Object Storage Documentation](https://cloud.ibm.com/docs/cloud-object-storage)
- [Terraform IBM Provider](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs)
- [AIX Migration Best Practices](https://www.ibm.com/docs/en/aix/)

---

**Nota**: Este é um ambiente de sandbox para fins de aprendizado e testes. Para migrações de produção, consulte especialistas e siga as melhores práticas da IBM.