# Instalando o terraform no Play With Docker
- Rodar sequência de comandos a seguir no terminal.

```
wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip
mv terraform /bin/
terraform
```

# Clonar o Repositório 
```
git clone https://github.com/rafaelbonilha/terraform-tomcat
cd terraform-tomcat 

````

# Rodar o Terraform

- Inicializar o terraform e automaticamente irá baixar os plugins necessários.

```
terraform init
```

- Verificar com o comando a seguir o que o terraform irá provisionar, esse comando é uma previa.

```
terraform plan
```

- Após verificar a saida, o comando apply vai construir a infra estrutura declarada no arquivo main.tf

```
terraform apply
```
- Confirmar com "yes" para realizar o deploy.
