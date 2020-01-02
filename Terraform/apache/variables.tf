#variable "azure_client_id" {  
#  type = "string"
#}

#variable "azure_client_secret" {  
#  type = "string"
#}

variable "azure_subscription_id" {  
  type    = string  
  default = "1f537a4d-a40c-4a5e-8a2c-5de58a917191"
}

variable "azure_tenant_id" {  
  type    = string
  default = "c160a942-c869-429f-8a96-f8c8296d57db"
}

variable "azure_location" {  
  type    = string
  default = "eastus"
}

variable "azure_resource_group" {  
  type    = string
  default = "lab05"
}

variable "azure_vnet" {  
  type    = string
  default = "lab05_vnet_web"
}

variable "azure_dns" {  
  type    = string
  default = "weblab05"
}

variable "azure_dns_bd" {  
  type    = string
  default = "bdlab05"
}

variable "azure_sizevm" {  
  type    = string
  default = "Standard_B1ms"
}

variable "admin_username" {  
  type     = string
  default  = "jcubillos555"
}

variable "admin_password" {  
  type     = string
  default  = "Proviteq.1999"
}