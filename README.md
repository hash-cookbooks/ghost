# ghost-env-cookbook

Minimal cookbook to setup a working ghost blog with nginx as proxy.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ghost']['user']</tt></td>
    <td>String</td>
    <td>The default user which will run ghost</td>
    <td><tt>ghost</tt></td>
  </tr>
  <tr>
    <td><tt>['ghost']['group']</tt></td>
    <td>String</td>
    <td>The default group where the user is in</td>
    <td><tt>ghost</tt></td>
  </tr>
  <tr>
    <td><tt>['ghost']['home']</tt></td>
    <td>String</td>
    <td>The users home folder and ghost installation folder</td>
    <td><tt>/srv/ghost</tt></td>
  </tr>
  <tr>
    <td><tt>['ghost']['version']</tt></td>
    <td>String</td>
    <td>The ghost version to install</td>
    <td><tt>latest</tt></td>
  </tr>
  <tr>
    <td><tt>['ghost']['port']</tt></td>
    <td>String</td>
    <td>The port where ghost runs</td>
    <td><tt>2368</tt></td>
  </tr>
</table>

## Usage

### ghost-env::default

Include `ghost-env` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ghost-env::default]"
  ]
}
```

## License and Authors

Author:: Hendrik Schaeidt (<he.schaeidt@gmail.com>)