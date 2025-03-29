from urllib.request import urlopen, urlretrieve
import json,os

os.chdir('/opt/epil')

release=urlopen("https://api.github.com/repos/EUVABECO/ePIL/releases/latest")
data = json.loads(release.read())

for asset in data['assets']:
  if (asset['name'] == 'htaccess'):
    access=urlopen(asset['browser_download_url'])
    content = access.read()
    with open('htaccess','wb') as file:
       file.write(content)
