import click
from normalize.pressures import PressureNormalizeWorkflowInterface
from normalize.forms import FormNormalizeWorkflowInterface
from normalize.donations import DonationNormalizeWorkflowInterface

@click.group()
def cli():
    pass


@click.command()
@click.option('--community', type=int, help='Community ID to use for normalize.')
@click.option('--action', help='The action kind name')
@click.option('--page', type=int, default=0)
def normalize(community, action, page):
    """Normalize Bonde actions to inserted on BigQuery dataset"""

    if action == "donation":
        DonationNormalizeWorkflowInterface(
            dict(community_id=community, action=action)).run()
    elif action == "pressure":
        PressureNormalizeWorkflowInterface(
            dict(community_id=community, action=action), limit=50000).run()
    elif action == "form":
        FormNormalizeWorkflowInterface(
            dict(community_id=community, action=action), limit=30000, page=page).run()


cli.add_command(normalize)

if __name__ == "__main__":
    # load_dotenv('../.env')
    cli()

# Community 8: (2) 29999
# Community 8: (2) 29942