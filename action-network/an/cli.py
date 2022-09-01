import click
from normalize.pressures import PressureNormalizeWorkflowInterface
from normalize.forms import FormNormalizeWorkflowInterface
from normalize.donations import DonationNormalizeWorkflowInterface
from sync.pressures import sync_actions as pressure_sync_actions
from sync.forms import sync_actions as form_sync_actions
from sync.donations import sync_actions as donations_sync_actions
from sync.tags import sync_tags_an, sync_tags_bg
from submit_actions import submit_actions
from update_activists import update_activists


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


@click.command()
@click.option('--community', type=int, help='Community ID to use for normalize.')
@click.option('--action', help='The action kind name')
def syncronize(community, action):
    """Syncronize Bonde widgets to inserted on Action Network and BigQuery dataset"""
    if action == "pressure":
        pressure_sync_actions(community_id=community)
    elif action == "form":
        form_sync_actions(community_id=community)
    elif action == "donation":
        donations_sync_actions(community_id=community)


@click.command()
@click.option('--community', type=int, help='Community ID to use for normalize.')
@click.option('--start')
@click.option('--end')
@click.option('--background', is_flag=True)
def submit(community, start, end, background):
    """Submit BigQuery activist actions to Action Network"""
    submit_actions(community, start, end, background)

@click.command()
@click.option('--community', type=int, help='Community ID to use for normalize.')
@click.option('--start')
@click.option('--end')
@click.option('--background', is_flag=True)
def update(community, start, end, background):
    """Update BigQuery activist actions to Action Network"""
    update_activists(community, start, end, background)


@click.command()
@click.option('--db', help='The database to insert tags')
def tags(db):
    """Syncronize Bonde tags to Big Query or Action Network"""
    if db == 'bq':
        sync_tags_bg()
    elif db == 'an':
        sync_tags_an()

cli.add_command(normalize)
cli.add_command(syncronize)
cli.add_command(tags)
cli.add_command(submit)
cli.add_command(update)


if __name__ == "__main__":
    # load_dotenv('../.env')
    cli()

# Community 8: (2) 29999
# Community 8: (2) 29942
