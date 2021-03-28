BeforeDiscovery{

    $pesterConfig = [PesterConfiguration]::Default
    $pesterConfig.Output.Verbosity = "Detailed"
    $PesterPreference = $pesterConfig

    . "$PSScriptRoot\validator.ps1"

    $testCases = @(
        @{
            key = 0
            input = "123456789456789123789123456912345678345678912678912345891234567234567891567891234"
            expectedResult = $true
        },
        @{
            key = 1
            input = "435269781682571493197834562826195347374682915951743628519326874248957136763418259"
            expectedResult = $true
        },
        @{
            key = 2
            input = "432269781685571493197834562826195347374682915951743628519326874248957136763418259"
            expectedResult = $false
        },
        @{
            key = 3
            input = "435269781682571493197834562826195347374682915159743628519326874248957136763418259"
            expectedResult = $false
        },
        @{
            key = 4
            input = "435269781682571493897134562126895347374682915951743628519326874248957136763418259"
            expectedResult = $false
        },
        @{
            key = 5
            input = "596142537614358248569412536195368416593634821595321456136486525412368492368741563"
            expectedResult = $false
        },
        @{
            key = 6
            input = "133456779456779133779133456913345677345677913677913345791334567334567791567791334"
            expectedResult = $false
        }

    )

    $grids = [ordered]@{}
    foreach($testCase in $testCases){

        $gridResult = [SudokuGrid]::new($testCases[$testCase.key].input)
        
        $grids.Add(
            $testCase.key, [PSCustomObject]@{
                grid = $gridResult
                finalResult = $gridResult.SolutionIsValid
                expectedResult = $testCase.expectedResult
            }
        )

    }

}

Describe "Validator class tests"{

    Context "Row Gets" {

        It "Rows should return a string array" {
            $grids[0].grid.rows.GetType().FullName | Should -Be "System.String[]"
        }

        It "Rows array should contain 9 items" {
            $grids[0].grid.rows.Length | Should -Be 9
        }

        It "Grid[0] rows array should contain items of expected values" {

            [array]$expectedRows = @(
                "123456789",
                "456789123",
                "789123456",
                "912345678",
                "345678912",
                "678912345",
                "891234567",
                "234567891",
                "567891234"
            )

            $comparison = Compare-Object $grids[0].grid.rows $expectedRows
            $comparison | Should -BeNullOrEmpty

        }

        It "Grid[1] rows array should contain items of expected values" {

            [array]$expectedRows = @(
                "435269781",
                "682571493",
                "197834562",
                "826195347",
                "374682915",
                "951743628",
                "519326874",
                "248957136",
                "763418259"
            )

            $comparison = Compare-Object $grids[1].grid.rows $expectedRows
            $comparison | Should -BeNullOrEmpty

        }

    }

    Context "Column gets" {

        It "Columns should return a string array" {
            $grids[0].grid.Columns.GetType().FullName | Should -Be "System.String[]"
        }

        It "Columns array should contain 9 items" {
            $grids[0].grid.Columns.Length | Should -Be 9
        }

        It "Grid[0] columns array should contain items of expected values" {

            $expectedColumns = @(
                "147936825",
                "258147936",
                "369258147",
                "471369258",
                "582471369",
                "693582471",
                "714693582",
                "825714693",
                "936825714"
            )

            $comparison = Compare-Object $grids[0].grid.Columns $expectedColumns
            $comparison | Should -BeNullOrEmpty

        }

        It "Grid[1] columns array should contain items of expected values" {

            $expectedColumns = @(
                "461839527",
                "389275146",
                "527641983",
                "258167394",
                "673984251",
                "914523678",
                "745396812",
                "896412735",
                "132758469"
            )

            $comparison = Compare-Object $grids[1].grid.Columns $expectedColumns
            $comparison | Should -BeNullOrEmpty

        }

    }

    Context "Subgrid gets" {

        It "Subgrid should return a string array" {
            $grids[0].grid.Subgrids.GetType().FullName | Should -Be "System.String[]"
        }

        It "Subgrids array should contain 9 items" {
            $grids[0].grid.Subgrids.Length | Should -Be 9
        }

        It "Grid[0] subgrids array should contain items of expected values" {

            $expectedSubgrids = @(
                "123456789",
                "456789123",
                "789123456",
                "912345678",
                "345678912",
                "678912345",
                "891234567",
                "234567891",
                "567891234"
            )

            $comparison = Compare-Object $grids[0].grid.Subgrids $expectedSubgrids
            $comparison | Should -BeNullOrEmpty

        }

        It "Grid[1] subgrids array should contain items of expected values" {

            $expectedSubgrids = @(
                "435682197",
                "269571834",
                "781493562",
                "826374951",
                "195682743",
                "347915628",
                "519248763",
                "326957418",
                "874136259"
            )

            $comparison = Compare-Object $grids[1].grid.Subgrids $expectedSubgrids
            $comparison | Should -BeNullOrEmpty

        }

    }

    Context "Helper checks" {

        it "makeNumberArray should generate array of 1..9"{
            [array]$expectedArray = @(1,2,3,4,5,6,7,8,9)
            $result = $grids[0].grid.makeNumberArray(9)

            $comparison = Compare-Object $result $expectedArray 
            $comparison | Should -BeNullOrEmpty
        }
        
    }

    Context "Row checks" {

        It "Grid[0] rows should validate as true"{
            $grids[0].grid.RowsAreValid | Should -BeTrue
        }

        It "Grid[2] rows should validate as false"{
            $grids[2].grid.RowsAreValid | Should -BeFalse
        }
        
    }

    Context "Column checks" {

        It "Grid[0] columns should validate as true"{
            $grids[0].grid.ColumnsAreValid | Should -BeTrue
        }

        It "Grid[3] columns should validate as false"{
            $grids[3].grid.ColumnsAreValid | Should -BeFalse
        }
        
    }

    Context "Subgrid checks" {

        It "Grid[0] subgrid should validate as true"{
            $grids[0].grid.SubgridsAreValid | Should -BeTrue
        }

        It "Grid[4] subgrid should validate as false"{
            $grids[4].grid.SubgridsAreValid | Should -BeFalse
        }
        
    }

}

Describe "Test-Sudoku function"{
    
    Context "Without pipeline" {
        It "Test case <key+1> result should be <expectedResult>." -TestCases $testCases{
            $grid = Test-Sudoku -Solution $_.input
            $grid.SolutionIsValid | Should -Be $expectedResult
        }
    }

    Context "With pipeline" {
        It "Test case <key+1> result should be <expectedResult>." {
            $grids = $testCases.input | Test-Sudoku

            
            foreach($testCase in $testCases){
                $grid = $grids | Where-Object Solution -eq $testCase.input
                if($grid.SolutionIsValid -eq $testCase.expectedResult){
                    $passTest = $true
                }
                else{
                    $passTest = $false
                    break
                }
            }
            $passTest | Should -BeTrue
        }
    }

}
