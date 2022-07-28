"""Utils functions"""

def find_by_ddd(ddd):
    """Return state by DDD"""
    states = dict(
      DF=['61', 'Distrito Federal'],
      GO=['62','64', 'Goiania', 'Goiânia'],
      MT=['65','66', 'Mato Grosso'],
      MS=['67', 'Mato Grosso do Sul'],
      AL=['82', 'Alagoas'],
      BA=['71','73','74','75','77', 'Bahia'],
      CE=['85','88', 'Ceará', 'Ceara'],
      MA=['98','99', 'Maranhão', 'Maranhao'],
      PB=['83', 'Paraíba', 'Paraiba'],
      PE=['81','87', 'Pernambuco'],
      PI=['86','89', 'Piauí', 'Piaui'],
      RN=['84', 'Rio Grande do Norte'],
      SE=['79', 'Sergipe'],
      AC=['68', 'Acre'],
      AP=['96', 'Amapá', 'Amapa'],
      AM=['92','97', 'Amazonas'],
      PA=['91','93','94', 'Para', 'Pará'],
      RO=['69', 'Rondônia', 'Rondonia'],
      RR=['95', 'Roraima'],
      TO=['63', 'Tocantins'],
      ES=['27','28', 'Espírito Santo', 'Espirito Santo'],
      MG=['31','32','33','34','35','37','38', 'Minas Gerais'],
      RJ=['21','22','24', 'Rio de Janeiro'],
      SP=['11','12','13','14','15','16','17','18','19', 'São Paulo', 'Sao Paulo'],
      PR=['41','42','43','44','45','46', 'Paraná', 'Parana'],
      RS=['51','53','54','55', 'Rio Grande do Sul'],
      SC=['47','48','49', 'Santa Catarina']
    )

    state = ddd

    for index, values in enumerate(states.values()):
        if ddd in values:
            state = list(states.keys())[index]
            break

    return state
