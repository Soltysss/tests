package terraform

import input.tfplan as tfplan


allowed_platforms = ["aws", "azurerm", "google"]
allowed_tags_key = ["owner", "test-env-owner"]
clouds_with_tags = ["aws", "azurerm"]


get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
}

res := tfplan.resource_changes

allowed_resources := [r | r = res[_]; allowed_platforms[_] == get_basename(r.provider_name)]
resources := [r | r = allowed_resources[_]; not "delete" == r.change.actions[0]]


#Check tags has owner key
deny[msg] {
    r := resources[_]
    provider_name := get_basename(r.provider_name)
    clouds_with_tags[_] == provider_name
    allowed_tags := [tag | tag := allowed_tags_key[_]; r.change.after.tags[tag]]
    count(allowed_tags) == 0
    msg := sprintf("Owner tag not exist on %s resource '%s' containes '%s'", [provider_name, r.address, r.change.after.tags])
}


# fix for gce
deny[msg] {
    r := resources[_]
    provider_name := get_basename(r.provider_name)
    provider_name == "google"
    r.change.after.labels
    allowed_tags := [tag | tag := allowed_tags_key[_]; r.change.after.labels[tag]]
    count(allowed_tags) == 0
    msg := sprintf("Owner tag not exist on GCE resource '%s'", [r.address])
}


