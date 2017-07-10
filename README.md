# Migrate VM Network Adapter

Este script é extremamente útil para migrar as interfaces de rede das máquinas virtuais de E1000 para VMXNET 3. Sei que quando é necessário efetuar esta modificação, muitos especialistas optam por editar o arquivo VMX de cada máquina virtual ou até mesmo remover a interface de rede E1000 e adicionar uma nova interface de rede VMXNET 3. Mas como todos sabem, se o MAC mudar, o sistema operacional guest irá identificar uma nova interface de rede, aí é necessário efetuar a reconfiguração do endereço IP. Dependendo da quantidade de máquinas virtuais, será muito trabalhoso (e desnecessário).

 - **Ações que o Script executa**
	 - **Seleciona as máquinas virtuais do vCenter Server de 4 formas diferentes**
		 - Datacenter
		 - Cluster
		 - Resource Pool
		 - Folder
	 - **Efetua diversas verificações**
		 - Se as VMs estão ligadas
		 - Se as VMs possuem interface de rede e1000
	 - **Migração**
		 - Com a VM desligada, ocorre a migração da interface de rede e1000 para VMXNET 3
 - **Compatibilidade**
	 - vSphere (ESXi e vCenter)
		 - Testado nas versões 5.1, 5.5, 6.0 e 6.5
	 - PowerCLI
		 - Recomendo a versão 6 ou superior
 - **Pré-requisitos**
	 - vCenter Server (Windows ou Appliance) versão 5 ou superior
		 - Garantir que o vCenter esteja acessivel pela rede
	 - VMware vSphere PowerCLI versão 6 ou superior

[Mais informações](http://solutions4crowds.com.br/script-migrate-virtual-machine-network-adapter)
