# Addressage réseaux

## Nécessité du protocole ipv6 7.2.1.1
- **Le manque d'address IP** est un des **facteurs les plus décisif**, en
faveur de la **transition vers cette architecture**.

- **L'augmentation de demande** des **addresse ip** en **afrique et en Asie et autre partie du monde**.

- L'ipv4 est limité a 4,3 milliard d'addresse ip.

- NAT endommage beaucoup d'application et **gênent les communication des application p2p**

- Avec l'**internet of Everything** l'ipv4 va vite devenir obsolète.

## Coexistence des protocoles IPv4 et IPv6 7.2.1.2
- Il n'y a pas de date prévue pour la transition vers de l'ipv6
- Pour l'instant l'ipv4 et ipv6 doivent coexisté.

- L'IETF a fait plusieur protocole et outils pour migré vers l'ipv6

### Technique de migration
- La double pile:
  - Permet d'avoir de l'ipv4 et de l'ipv6 sur le même segment réseaux.
  - Les P double pile exécute la pile IPV4 et IPV6 simultanément.  


- Le tunneling:
  - Permet de transporté des donnée ipv6 dans un réseaux ipv4
  - Les paquet ipv6 sont encapsulé dans des paquet ipv4


- La traduction:
  - P ipv6 peuvent utilisé le NAT64 pour aller vers un réseaux ipv4.
  - Technique similaire au NAT
  - Paquet ipv6 est traduit en ipv4 et inversement


#### Remarque
  - La traduction et le tunneling sont utilisé uniquement quand nécessaire
  - 
