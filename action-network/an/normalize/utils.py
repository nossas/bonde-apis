"""Utils functions"""

def find_by_ddd(ddd):
    """Return state by DDD"""
    states = dict(
      DF=['61'],
      GO=['62','64'],
      MT=['65','66'],
      MS=['67'],
      AL=['82'],
      BA=['71','73','74','75','77'],
      CE=['85','88'],
      MA=['98','99'],
      PB=['83'],
      PE=['81','87'],
      PI=['86','89'],
      RN=['84'],
      SE=['79'],
      AC=['68'],
      AP=['96'],
      AM=['92','97'],
      PA=['91','93','94'],
      RO=['69'],
      RR=['95'],
      TO=['63'],
      ES=['27','28'],
      MG=['31','32','33','34','35','37','38'],
      RJ=['21','22','24'],
      SP=['11','12','13','14','15','16','17','18','19'],
      PR=['41','42','43','44','45','46'],
      RS=['51','53','54','55'],
      SC=['47','48','49']
    )

    state = ddd

    for index, values in enumerate(states.values()):
        if ddd in values:
            state = list(states.keys())[index]
            break

    return state
