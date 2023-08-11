resource "azurerm_subnet" "PTS-sb" {
  name                 = var.PTS-sb-name
  resource_group_name  = var.resource-group-name
  virtual_network_name = var.vnet-name
  address_prefixes     = var.PTS-sb-address_prefixes
}

resource "azurerm_local_network_gateway" "PTS-LNGonpremise" {
  name                = var.PTS-LNGonpremise-name
  location            = var.location
  resource_group_name = var.resource-group-name
  gateway_address     = var.PTS-LNGonpremise-gateway_address
  address_space       = var.PTS-LNGonpremise-address_space
}

resource "azurerm_public_ip" "PTS-pip" {
  name                = var.PTS-pip-name
  location            = var.location
  resource_group_name = var.resource-group-name
  allocation_method   = var.PTS-pip-allocation_method
}

resource "azurerm_virtual_network_gateway" "PTS-VNG" {
  name                = var.PTS-VNG-name
  location            = var.location
  resource_group_name = var.resource-group-name

  type     = var.PTS-VNG-type
  vpn_type = var.PTS-VNG-vpn_type

  active_active = var.PTS-VNG-active_active
  enable_bgp    = var.PTS-VNG-enable_bgp
  sku           = var.PTS-VNG-sku

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.PTS-VNG.id
    private_ip_address_allocation = var.PTS-VNG-ipc-private_ip_address_allocation
    subnet_id                     = azurerm_subnet.PTS-sb.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "PTS-VNGC" {
  name                = var.PTS-VNGC-name
  location            = var.location
  resource_group_name = var.resource-group-name

  type                       = var.PTS-VNGC-type
  virtual_network_gateway_id = azurerm_virtual_network_gateway.PTS-VNG.id
  local_network_gateway_id   = azurerm_local_network_gateway.LNGonpremise.id

  shared_key = var.PTS-VNGC-shared_key
}
