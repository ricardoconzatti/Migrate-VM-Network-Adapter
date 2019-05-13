# Migrate VM Network Adapter

Este script é extremamente útil para migrar as interfaces de rede das máquinas virtuais de E1000 / E1000E para VMXNET 3. Sei que quando é necessário efetuar esta modificação, muitos especialistas optam por editar o arquivo VMX de cada máquina virtual ou até mesmo remover a interface de rede E1000 / E1000E e adicionar uma nova interface de rede VMXNET 3.

O script que escrevi consegue ler as máquinas virtuais que você escolher (pode buscar no datacenter, cluster, resource pool ou folder), verifica se todas as máquinas virtuais estão desligadas e também se todas possuem pelo menos uma interface de rede E1000, por fim lhe questiona se deseja continuar para a migração, basta aceitar para que as modificações nas máquinas virtuais sejam iniciadas. Assim, a interface de rede será migrada e o MAC Address continuará o mesmo. É possível que reconfigurações do endereço IP sejam necessárias. De qualquer forma recomendo que seja feito uma analise e entendimento do código antes de executar em ambiente de produção.

 - **Ações que o Script executa**
	 - **Seleciona as máquinas virtuais do vCenter Server de 4 formas diferentes**
		 - Datacenter
		 - Cluster
		 - Resource Pool
		 - Folder
	 - **Efetua diversas verificações**
		 - Se as VMs estão ligadas
		 - Se as VMs possuem interface de rede E1000 ou E1000E
	 - **Migração**
		 - Com a VM desligada, ocorre a migração da interface de rede E1000 e/ou E1000E para VMXNET 3
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
