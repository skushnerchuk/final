Здесь лежат скрипты терраформа

Terraform для развертывания кластера Kubernetes в GKE

Для хранения файлов состояния terraform используем 
[Terraform Cloud Remote State Management](https://www.hashicorp.com/blog/using-terraform-cloud-remote-state-management)

Файла состояния который храниться удаленно в Remote State Management гарантирует что у всех всегда есть самый последний файл состояния.  Terraform Remote State Management также блокирует файл состояния во время внесения изменений. 

Что бы запустить
* Step 0 - Sign up for a Terraform Cloud account here

* Step 1 -  An email will be sent to you, follow the link to activate your free Terraform Cloud account.

* Step 2 - When you log in, you’ll land on a page where you can create your organization or join an existing one if invited by a colleague.

* Step 3 - Next, go into User Settings and generate a token.

* Step 4 - Take this token and create a local ~/.terraformrc file:

```
credentials "app.terraform.io" {
    token = "mhVn15hHLylFvQ.atlasv1.jAH..."
}
```

* Step 6 - Run `terraform init` and you’re done.

* Strp 7 - Run `terraform apply` to start cluster 
