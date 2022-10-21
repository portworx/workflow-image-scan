# Reusable GitHub Workflow to Scan Images

> This workflow is highly specific for a few Portworx-internal repositories - may not be suited for generic usage.

The main goal this workflow is to:

1. Call Lacework scanner action ([lacework/lw-scanner-action](https://github.com/lacework/lw-scanner-action)) for the
   input images.
2. Build a scan result summary section and add it to the end of the Actions run page.
3. Add a comment into the pull request containing the scan results in short form.

## Usage

### With inherited secrets

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

Prerequisites to use:

* The caller repository must be under the Portworx organization.
* The caller repository must have added all the secrets defined in the [Inputs](#inputs) section below (using the same
  names).

### With explicit secrets

The caller cannot use the `implicit` keyword if the caller workflow is not from the Portworx organization
([doc](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idsecretsinherit)).
In this case the secrets must be defined explicitly:

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

## <a id="inputs"></a>Inputs

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

* Image scan results are:
    * visualized in the job summary section,
    * visualized in a pull request comment (if the scan result is different from the previous),
    * uploaded as artifacts into workflow run page as separate JSON files per image (
      e.g. `docker.io-portworx-pds-base-config-ubi8-a2aee61.lacework-result.json`).
