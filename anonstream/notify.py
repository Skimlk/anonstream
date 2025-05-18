from quart import current_app
from anonstream.stream import get_stream_title

from feedgen.feed import FeedGenerator
import uuid

def update_feed(title, author, url):
    fg = FeedGenerator()

    fg.title(title)
    fg.author(name=author)
    fg.subtitle('anonstream')
    fg.link(href=url, rel='alternate')

    fe = fg.add_entry()
    fe.id(uuid.uuid4().hex[:6].upper())
    fe.title(title)
    fe.link(href=url)

    fg.rss_str(pretty=True)
    fg.rss_file(current_app.root_path / 'rss.xml')
