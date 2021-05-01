# vscode_ros2_ws

ORise Robotics' VSCode workspace. It provides a [.code-workspace](https://code.visualstudio.com/docs/editor/multi-root-workspaces) configuration to be used inside a ros2 [ORise container](https://github.com/orise-robotics/ros_ws)

## How to setup

Basically, the workspace file requires the definition of an environment variabled called `COLCON_WORKSPACE_FOLDER`, which is assumed to be the place where the formatting configuration folder `.vscode-format` and the colcon base-folders (`build`, `install`, `log`) live.

To work with containers, this package provides the helper script `setup_workspace.sh`: it copies the `ros2.code-workspace` file and the `.vscode-format/` folder to inside the specified container, which is assumed to be running. It also creates a named remote container configuration file to allow attaching to the container as an specific user (`orise` by default).

Run `setup_workspace.sh --help` for more details about the script usage.

If you're using [ORise container](https://github.com/orise-robotics/ros_ws), it assumes that the folder `/home/orise`
will be used as your woskspace to develop using ROS 2 and also, your VSCode workspace. If you want to use different workspaces inside the container, just copy the files `.vscode-format` and `ros2.code-workspace` to the root of your ROS workspace and redefine the `COLCON_WORKSPACE_FOLDER` variable. For example, let's assume that you want to use a ROS 2 woskpace called *foxy_ws*, this folder should have:

- foxy_ws
  - `.vscode-format`
  - `ros2.code-workspace`
  - *build*
  - *install*
  - *log*
  - *src*

And you must redefine the `COLCON_WORKSPACE_FOLDER` variable:

```sh
  export COLCON_WORKSPACE_FOLDER=/home/orise/foxy_ws
```

### Folders Configuration

In order to have the desired folders opened when you open the VSCode workspace you should add them to the `ros2.code-workspace`:

```json
  // FOLDERS
  "folders": [
    {
      "path": "foxy_ws"
    }
  ],
```
Another way of doing this is using graphical interface. Check [this tutorial](https://code.visualstudio.com/docs/editor/multi-root-workspaces#_adding-folders) for more information

## Workspace features

Recommend convenient extensions, configure formatting and linting tools, and provide helper tasks and build/test/debug launchs.

### Formatting & linting configurations

The workspace try to offer full formatting and linting tools to accomplish the rules defined by [`ament_lint_common`](https://github.com/ament/ament_lint/tree/master/ament_lint_common)

- **Python:** compatible with [`amment_flake8`](https://github.com/ament/ament_lint/tree/master/ament_flake8) and [`ament_pep257`](https://github.com/ament/ament_lint/tree/master/ament_pep257) using tools like [`yapf`](https://github.com/google/yapf), [`isort`](https://pycqa.github.io/isort/), [`flake8`](https://flake8.pycqa.org/en/latest/)
- **C++:** compatible with [`amment_uncrustify`](https://github.com/ament/ament_lint/tree/master/amment_uncrustify), [`amment_cpplint`](https://github.com/ament/ament_lint/tree/master/amment_cpplint), [`amment_cppcheck`](https://github.com/ament/ament_lint/tree/master/amment_cppcheck)
- **CMake:** compatible with [`ament_lint_cmake`](https://github.com/ament/ament_lint/tree/master/ament_lint_cmake) using [`cmake-format`](https://marketplace.visualstudio.com/items?itemName=cheshirekow.cmake-format)
- **XML:** compatible with [`ament_xml_lint`](https://github.com/ament/ament_lint/tree/master/ament_xml_lint)
- **Yaml**

### Tasks & Launch

Adapt tasks and launchs from [athackst/vscode_ros2_workspace](https://github.com/athackst/vscode_ros2_workspace)
