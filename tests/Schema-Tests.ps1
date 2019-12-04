function Get-SqlSchemaLines {
    (Get-ChildItem -Path $Env:PathToSql | Get-Content -Raw).Replace("`r`n", ' ').Split("GO")
}

if (!$Env:PathToSql) {
    $Env:PathToSql = 'C:\Users\assaf\source\repos\demos\DatabaseDevOps\AdventureWorks2016\AdventureWorks2016\bin\Debug\AdventureWorks2016_Update4.publish.sql'
}

$DROP_COLUMNS_EXPRESSION = 'ALTER\s+TABLE.+?DROP\s+\['
$ALTER_COLUMNS_EXPRESSION = 'ALTER\s+TABLE.+?ALTER\s+\['
$Lines = Get-SqlSchemaLines
Write-Host "Lines: $Lines"

Describe "Upgrade database schema" {
    Context "The SQL schema upgrade script" {
        It "doesn't drop columns" {
            $found = Get-SqlSchemaLines | Select-String -Pattern $DROP_COLUMNS_EXPRESSION

            $found | Should -BeNullOrEmpty
        }

        It "doesn't alter columns" {
            $found = Get-SqlSchemaLines | Select-String -Pattern $ALTER_COLUMNS_EXPRESSION

            $found | Should -BeNullOrEmpty
        }
    }
}