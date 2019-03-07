

{% if aws == true %}
aws_access_key = "{{ aws_access_key }}"
aws_secret_key = "{{ aws_secret_key }}"
aws_region     = "{{ aws_region }}"

{% for {{ aws_number_agent }} in range(1,n) %}


Deploy


{% endfor %}




{% endif %}












{% if pazurerm == true %}
azurerm_subscription_id = "{{ azurerm_subscription_id }}"
azurerm_client_id       = "{{ azurerm_client_id }}"
azurerm_client_secret   = "{{ azurerm_client_secret }}"
azurerm_tenant_id       = "{{ azurerm_tenant_id }}"
{% endif %}

{% if google == true %}
google_credentials = "${file("google_account.json")}"
google_project     = "{{ google_project }}"
google_region      = "{{ google_region }}"
{% endif %}