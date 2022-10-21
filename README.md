# Reusable GitHub Workflow to Scan Images

> This workflow is highly specific for a few Portworx-internal repositories - may not be suited for generic usage.

The main goal this workflow is to:

1. call Lacework scanner action ([lacework/lw-scanner-action](https://github.com/lacework/lw-scanner-action)) for the
   input images,
2. builds a scan result summary section and adds it to the end of the Actions run page,
3. adds a comment into the pull request containing the scan results in short form.

## Usage

```yml
jobs:
  # ...
  image-scan:
    needs: [ other-job1, other-job2 ]
    uses: portworx/workflow-image-scan/.github/workflows/image-scan.yml
    with:
      images: ${{ needs.other-job1.outputs.image }} ${{ needs.other-job2.outputs.image }}
    secrets: inherit
```

or with explicit secrets:

```yml
jobs:
  image-scan:
    uses: portworx/workflow-image-scan/.github/workflows/image-scan.yml
    with:
      images: 'docker.io/busybox:1.35.0' 'docker.io/redhat/ubi8:8.6'
    secrets:
      DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
      DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      LW_ACCOUNT_NAME: ${{ secrets.LW_ACCOUNT_NAME }}
      LW_ACCESS_TOKEN: ${{ secrets.LW_ACCESS_TOKEN }}
```

## Inputs

```yml
    inputs:
      # Space-separated list of images (e.g. "docker.io/busybox:1.35.0 docker.io/redhat/ubi8:8.6").
      images:
        required: true
        type: string
    secrets:
      # Docker username.
      DOCKER_USERNAME:
        required: true
      # Docker password.
      DOCKER_PASSWORD:
        required: true
      # Lacework account name.
      LW_ACCOUNT_NAME:
        required: true
      # Lacework access token.
      LW_ACCESS_TOKEN:
        required: true
```

## Outputs

Image scan results visualized in:

1. job summary section,
2. pull request comment.
