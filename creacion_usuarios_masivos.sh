#!/bin/bash

#BIENVENIDOS AL MENU , LAS FUNCIONES DE ESTE SON AQUELLAS QUE APARECERAN EN PANTALLA
 	while :
  	do
 			#MENU DE FUNCIONES , la primera opcion buscamos el usuario en dominio ldap , la segunda opcion agregamos o añadimos 
			#el usuario al ldap y opcion tres lo que hacemos es buscar toda la informacion de usuarios y grupos de ldap
 				echo "1) Buscar un usuario en el LDAP:"
 				echo "2) Introducir un usuario en el LDAP:"
 				echo "3) Buscar la informacion generica de todo ldap:"
 				echo "4) salir"
 				echo""

 				#escogemos ahora una opcion del menu
 				echo -n "escoge una opcion: "
 				read opcion
 				case $opcion in

 					1) echo -n Introduce el usuario que deseas buscar:
					read usuario
					ldapsearch -xLL -b "dc=LaTerapia,dc=com" uid=$usuario sn givenName mail
					;;

					2) aux=$(sudo cat userAuto.ldif | grep uidNumber | cut -d ":" -f 2) 
					echo -n introduce el nombre de usuario que deseas agregar:
					read usuario
					#################################################
					echo  "dn:uid=$usuario,ou=LaTerapia,dc=LaTerapia,dc=com" > userAuto.ldif
			#creamos un fichero que se llama userAuto.ldif y volcamos los datos introducidos en este fichero en el .ldif
					echo "objectClass:inetOrgPerson" >> userAuto.ldif
					echo "objectClass:posixAccount" >> userAuto.ldif
					echo "objectClass:shadowAccount" >> userAuto.ldif
					echo "objectClass:person" >> userAuto.ldif
					###############################################
					echo "uid:$usuario" >> userAuto.ldif
					##############################################
					echo sistemas
					echo recursos_humanos
					echo secretaria
					echo psicologos_empresa
					echo -n introduce el grupo al cual deseas agregar al usuario:
					read grupo
					#############################################
					echo "ou:$grupo" >> userAuto.ldif
					echo "cn:$usuario" >> userAuto.ldif
					num=$(expr $aux + 1)
					echo "uidNumber:$num" >> userAuto.ldif
					echo "gidNumber:20000" >> userAuto.ldif
					echo "homeDirectory:/home/$usuario" >> userAuto.ldif
					echo "loginShell:/bin/bash" >> userAuto.ldif
					##############################################
					echo "userPassword:123" >> userAuto.ldif
					echo -n introduce tu apellido:
					read apellido
					echo "sn:$apellido" >> userAuto.ldif
					echo "mail:$usuario@LaTerapia.com" >> userAuto.ldif
					echo "givenName:$usuario" >> userAuto.ldif
					#echo " " >> userAuto.ldif
					sudo ldapadd -x -D 'cn=admin,dc=LaTerapia,dc=com' -W -f userAuto.ldif

					;;
					3) sudo slapcat

					;;
					4) exit 0;;
					##ALERTA
						*)echo "opcion invalida..."
						sleep 1
esac

 done
