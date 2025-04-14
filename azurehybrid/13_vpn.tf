resource "azurerm_virtual_network_gateway" "ysjang_vpn" {
  name                = "ysjang-vpn"
  location            = azurerm_resource_group.ysjang_rg.location
  resource_group_name = azurerm_resource_group.ysjang_rg.name


  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2AZ"
  generation    = "Generation2"


  ip_configuration {
    name                          = "ysjang-vpn-ip3"
    public_ip_address_id          = azurerm_public_ip.ysjang_vpn_ip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.ysjang_vpn.id
  }

}

resource "azurerm_local_network_gateway" "ysjang_localgw" {
  name                = "ysjang-localgw"
  resource_group_name = azurerm_resource_group.ysjang_rg.name
  location            = azurerm_resource_group.ysjang_rg.location
  gateway_address     = "1.220.76.4"
  address_space       = ["192.168.126.0/24"]

}


resource "azurerm_virtual_network_gateway_connection" "ysjang_vpncon" {
  name                       = "ysjang-onprem-connection"
  location                   = azurerm_resource_group.ysjang_rg.location
  resource_group_name        = azurerm_resource_group.ysjang_rg.name
  enable_bgp                 = false
  connection_protocol        = "IKEv2"
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.ysjang_vpn.id
  local_network_gateway_id   = azurerm_local_network_gateway.ysjang_localgw.id
  shared_key                 = "roqkfdnjs12!@"

  ipsec_policy {
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    dh_group         = "DHGroup2"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS2"
    sa_lifetime      = 3600
    sa_datasize      = 2147483647
  }
  dpd_timeout_seconds = 45
}
