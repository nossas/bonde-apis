import click
import enlighten
# from dotenv import load_dotenv
from logger import logging
# Normalize Functions
from normalize import donations, forms, pressures

# Setup progress bar
manager = enlighten.get_manager()

status_format = '{program}{fill}Stage: {stage}{fill} Status {status}'

@click.group()
def cli():
    pass

@click.command()
@click.option('--community', type=int, help='Community ID to use for normalize.')
@click.option('--action', help='The action kind name')
def normalize(community, action):
    """Normalize Bonde actions to inserted on BigQuery dataset"""
    logging.info(f'Normalize {action} to Community {community}.')

    sbar = manager.status_bar(status_format=status_format,
                                color='bold_slategray',
                                program='Demo',
                                stage=f'Normalize {action} to Community {community}',
                                status='START')

    if action == "donation":
        donations.run(community)
    elif action == "pressure":
        pressures.run(community)
    elif action == "form":
        forms.run(community, sbar, manager)

cli.add_command(normalize)

if __name__ == "__main__":
    # load_dotenv('../.env')
    cli()