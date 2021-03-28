BeforeDiscovery{

    $testCases = @(
        [PSCustomObject]@{
            key = 0
            input = "123456789456789123789123456912345678345678912678912345891234567234567891567891234"
            expectedResult = $true
        },
        [PSCustomObject]@{
            key = 1
            input = "435269781682571493197834562826195347374682915951743628519326874248957136763418259"
            expectedResult = $true
        },
        [PSCustomObject]@{
            key = 2
            input = "432269781685571493197834562826195347374682915951743628519326874248957136763418259"
            expectedResult = $false
        },
        [PSCustomObject]@{
            key = 3
            input = "435269781682571493197834562826195347374682915159743628519326874248957136763418259"
            expectedResult = $false
        },
        [PSCustomObject]@{
            key = 4
            input = "435269781682571493897134562126895347374682915951743628519326874248957136763418259"
            expectedResult = $false
        },
        [PSCustomObject]@{
            key = 5
            input = "596142537614358248569412536195368416593634821595321456136486525412368492368741563"
            expectedResult = $false
        },
        [PSCustomObject]@{
            key = 6
            input = "133456779456779133779133456913345677345677913677913345791334567334567791567791334"
            expectedResult = $false
        }

    )
}

BeforeAll{
    . "$PSScriptRoot\validator.ps1"

    $grid0 = [SudokuGrid]::new($testCases[0].input)
    $grid1 = [SudokuGrid]::new($testCases[1].input)
    $grid2 = [SudokuGrid]::new($testCases[2].input)
}

Describe "Validator tests"{

    Context "Row Gets" {

        It "Rows should return an array" {
            $grid0.rows.GetType().FullName | Should -Be "System.Object[]"
        }

        It "Rows array should contain 9 items" {
            $grid0.rows.Length | Should -Be 9
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

            $comparison = Compare-Object $grid0.rows $expectedRows
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

            $comparison = Compare-Object $grid1.rows $expectedRows
            $comparison | Should -BeNullOrEmpty

        }

    }

    Context "Sequence checks" {

        it "Sequence should have expected digits"{
            [array]$expectedArray = @(1,2,3,4,5,6,7,8,9)
            $result = $grid0.makeNumberArray(9)

            $comparison = Compare-Object $result $expectedArray 
            $comparison | Should -BeNullOrEmpty
        }
        
    }

    Context "Row checks" {

        It "Grid[0] rows should validate as true"{
            $grid0.RowsAreValid | Should -BeTrue
        }

        It "Grid[2] rows should validate as false"{
            $grid2.RowsAreValid | Should -BeFalse
        }
        
    }

    Context "Column gets" {

        It "Should do"{
            $false | Should -BeTrue
        }

    }

    Context "Subgrid gets" {

        It "Should do"{
            $false | Should -BeTrue
        }

    }

}
