#!/usr/bin/env bash
set -e

REPO="simpscal/notism"

create_label() {
  local name="$1"
  local description="$2"
  local color="$3"
  echo "Creating label: $name"
  gh label create "$name" \
    --repo "$REPO" \
    --description "$description" \
    --color "$color" \
    --force
}

create_label "requirement"          "PO requirement"                             "e4e669"
create_label "user-story"           "BA-created story"                           "c2e0c6"
create_label "technical-design"     "TDD issue"                                  "6f42c1"
create_label "in-progress"          "Dev in progress"                            "d93f0b"
create_label "implemented"          "Dev implementation complete"                "0e8a16"
create_label "sprint-completed"     "Sprint closed"                              "006b75"
create_label "story-updated"        "Story amended after creation"               "bfd4f2"
create_label "story-removed"        "Story removed during requirement change"    "e4e669"
create_label "requirement-updated"  "Requirement updated after change"           "fef2c0"
create_label "bug-production"       "Reporter-created bug issue"                 "d73a4a"
create_label "bug-fixed"            "Bug resolved and closed"                    "0e8a16"

echo "Done. All labels created."
