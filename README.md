# Aplicação docker no raspberry pi
Docker é legal!

## Configuração inicial do raspberry pi
O primeiro passo para a subir uma aplicação rodando em docker no raspberry pi, é configurar a máquina instalando uma OS e, posteriormente, configurar o método de conexão pelo serviço SSH dentro de sua máquina.

### Instalando uma OS
Para instalação de uma OS no raspberry pi você vai precisar dos seguintes itens:
- Adaptador de cartão micro SD para usb (Para conectar no computador)
- Um cartão micro SD que esteja formatado em exfat ou fat32;
- O programa ["Raspberry Pi Imager"](https://www.raspberrypi.com/software/) instalado em uma máquina

Tendo todos os itens necessários, conecte seu cartão micro SD no computador que possua o "Raspberry Pi Imager" instalado. Abra o programa e siga o passo a passo a seguir:


![SelectDevice](/mgt/images/SelectDevice.PNG)

O primeiro passo é selecionar o dispositivo. Para saber qual dispositivo deve ser selecionado basta olhar à sua placa. Nela está escrito o modelo do dispositivo.


![SelectDevice2](/mgt/images/SelectDevice2.PNG)

Selecione o dispositivo correspondente ao qual você possui.

![ChooseOS](/mgt/images/ChooseOS.PNG)

Clique no botão "CHOOSE OS".

![ChooseOS3](/mgt/images/ChooseOS3.PNG)

Selecione "Other general-purpose OS".

![ChooseOS4](/mgt/images/ChoosOS4.PNG)

Agora selecione a imagem correspondente ao número de bits do processador da sua placa (para saber essa informação, basta pesquisar o modelo da placa na internet).

![ChooseStorage](/mgt/images/choose-storage.png)

Após isso, selecione a opção choose Storage, e selecione seu cartão micro SD.

![EditSettings](/mgt/images/os-customisation-prompt%20(1).png)

Selecione a opção: "Edit settings".

![EdtitSettings1](/mgt/images/os-customisation-general.png)

- Desabilite a opção "Set hostname";
- Habilite a opção "Set username and password" e defina um usuário juntamente de uma senha para o seu sistema;
- Caso sua placa necessite de se conectar à internet via wifi, habilite a opção "Configure wireless LAN" e configure com as informaçãos da sua rede doméstica. Caso esteja usando cabo, apenas desabilite a opção.
- Configure a opção "Set locale settings";

![SSHConfigure](/mgt/images/os-customisation-services.png)

Nessa página, habilite o serviço ssh e o configure conforme o indicado. **O recomendado é configurar o SSH com o método de autenticação via chaves.**

![OptionsConfigure](/mgt/images/os-customisation-options.png)

Assinale as opções indicadas. E clique em "Save"

![Finished](/mgt/images/finished.png)

Assim que o processo de gravação for finalizado, essa mensagem será exibida. Para concluir clique na opção "Continue".

![BootMidia](/mgt/images/sd-card.png)

Agora, pegue o cartão micro SD com a imagem gravada, e o instale na máquina. Para isso, basta inserir o cartão no seguinte compartimento.

### Configurando o serviço ssh dentro do raspberry pi:
Se os passos anteriores foram completos com exito, após o boot da máquina, o serviço SSH já deverá estar configurado.
Para conectar no dispositivo, use o comando:
```bash
 ifconfig 
 ```

 E ali procure o IP local do seu dispositivo, que se encontra conectado em sua rede.

 Para testar Se o serviço, use uma máquina conectada à mesma rede local do rasp, e use o seguinte comando:

 ```bash
ssh -i chave.pem user@iplocal
 ```

 Caso você tenha configurado seu SSH com o sistema de autenticação via senha, digite o seguinte comando:

 ```bash
ssh user@iplocal
 ```

O próximo passo, para caso você deseje que a conexão ssh funcione fora de sua rede local, é mudar a porta que o serviço SSH escuta. Esse passo é importante pois a maioria das provedoras de internet bloqueiam as portas baixas. Naturalmente, por conta dessa limitação, a porta 22 (porta padrão do SSH) será bloqueada quando acessada pelo IP público.

Para isso, no raspberry pi, deveremos acessar o arquivo de configuração do SSH.

```bash
#Acesse com o nano esse arquivo.
#Caso o editor de texto nano, não esteja instalado na máquina
#Digite o comando "sudo apt install nano"
sudo nano /etc/ssh/sshd_config
```

Ao entrar nesse arquivo, retire a # do seguinte comando, altere a porta e salve:

```bash
...
Port 2222
...
```

Feito isso, renicie o dispositivo.

## Instalando o docker

### Atualizando o instalador de pacotes do linux:

```bash
sudo apt update
```

### Instalação:

```bash
sudo apt install docker.io -y
```

para testar se a instalação foi feita com êxito, digite o comando:

```bash
sudo docker ps
```

### Rodando comandos docker sem o sudo:
```bash
sudo usermod -aG docker $USER
```

fonte: https://github.com/jeancosta4/Docker

## Criando um container e comando link

Agora vamos criar um container da aplicação.
O primeiro passo é ter subido sua imagem para o [Docker Hub](https://hub.docker.com).

Feito isso, vamos criar, primeiramente, o container do banco de dados. Para isso digite o seguite comando:

```bash
docker run --name db -p 3306:3306 mysql:5.7
```

Nota: Faltam as configurações de ambiente.

Agora configure o banco de dados

```bash
docker exec -it db bash
```
E depois
```bash
mysql -u user -p 
```
Agora crie as tabelas e databases necessárias;

Voltando com o comando CTRL + D

Crie o container da aplicação:

```bash
docker run --name app --link db -p 5000:5000 sua_imagem
```