tfm  init
tfm plan  -out tfplan.binary
tfm show -json tfplan.binary > plan.json
infracost breakdown --path plan.json