import click
# from dotenv import load_dotenv
from logger import logging
# Normalize Functions
from normalize import donations
from normalize import pressures

@click.group()
def cli():
    pass

@click.command()
@click.option('--community', type=int, help='Community ID to use for normalize.')
@click.option('--action', help='The action kind name')
def normalize(community, action):
    """Normalize Bonde actions to inserted on BigQuery dataset"""
    logging.info("Starting pipeline for normalize {} actions to community {}".format(action, community))
    if action == "donation":
        donations.run(community)
    elif action == "pressure":
        pressures.run(community)

cli.add_command(normalize)

if __name__ == "__main__":
    # load_dotenv('../.env')
    cli()