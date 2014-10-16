#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2014, Paul Tagliamonte <tag@pault.ag>
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.


DOCUMENTATION = '''

'''

EXAMPLES = '''
'''
import docker
import docker.errors

c = docker.Client(base_url='unix:///run/docker.sock',
                  version='1.12',
                  timeout=10)


def main():
    module = AnsibleModule(
        argument_spec=dict(
            image=dict(required=True),
            pulled=dict(required=True, choices=BOOLEANS),
            state=dict(default='present', choices=['present', 'absent']),
        )
    )
    image, pulled, state = (module.params[x] for x in
                            ['image', 'pulled', 'state'])
    info = {}
    try:
        info = c.inspect_image(image)
        exists = True
    except docker.errors.APIError:
        exists = False

    if state == 'absent' and exists:
        c.remove_image(image)

    if pulled or state == 'present' and not exists:
        # ugh
        image_, tag = (image, None)
        if ":" in image:
            image_, tag = image.rsplit(":", 1)
        for _ in c.pull(image_, tag=tag, stream=True):
            pass  # Hang on the pull

    ninfo = c.inspect_image(image)
    if ninfo["Id"] != info.get("Id"):
        module.exit_json(changed=True, image=image)
    else:
        module.exit_json(changed=False, image=image)


from ansible.module_utils.basic import *
main()
