
enum SequenceType{
    rows
    columns
    subgrids
}

class SudokuGrid {
    [string]$Solution
    [array]$Rows
    [array]$Columns
    [array]$Subgrids
    [bool]$RowsAreValid
    [bool]$ColumnsAreValid
    [bool]$SubgridsAreValid
    [bool]$SolutionIsValid


    SudokuGrid($Solution){
        $this.Solution = $Solution
        $this.Rows = $this.getRows($Solution)
        $this.Columns = $this.getColumns($Solution)
        $this.SubGrids = $this.getSubgrids($Solution)

        $this.checkSequence($this.Rows, "rows")
        $this.checkSequence($this.Columns, "columns")
        $this.checkSequence($this.Subgrids, "subgrids")

        $allValid = $false
        if(
            $this.RowsAreValid -eq $true `
            -and $this.ColumnsAreValid -eq $true `
            -and $this.SubgridsAreValid -eq $true `
        ){
            $allValid = $true
        }
        $this.SolutionIsValid = $allValid

    }


    [string[]]getRows($Solution){

        [string[]]$output = @()
        [string]$shrink = $Solution
        do {
            $output += $shrink.Substring(0,9)
            $shrink = $shrink.Substring(9)
            
        } while ($shrink.Length -gt 0)

        return $output

    }


    [string[]]getColumns($Solution){

        [int]$totalColumns = [math]::Sqrt($Solution.Length)
        [hashtable]$columnsDict = @{}
        $shrink = $Solution

        [int]$columnOrdinal = 1
        do {

            if($null -eq $columnsDict[$columnOrdinal]){
                $columnsDict.Add($columnOrdinal, "")
            }          

            $columnsDict[$columnOrdinal] += $shrink.Substring(0,1)
            $shrink = $shrink.Substring(1)
            
            $columnOrdinal++
            if($columnOrdinal -gt $totalColumns){
                $columnOrdinal = 1
            }

        } while ($shrink.Length -gt 0)

        [string[]]$output = @()
        $columnsDict.GetEnumerator() | 
            Sort-Object -Property Name |
            ForEach-Object {
                $output += ,$_.value
            }

        return $output
    }


    [string[]]getSubgrids($Solution){

        $stringLength = [math]::Sqrt($Solution.Length)
        $subGridLength = [math]::Sqrt($stringLength)

        [hashtable]$subgridCollection = @{}
        $shrink = $Solution

        [int]$subgridId = 1
        [int]$rowId = 0
        do {

            $rowId++
            for ($i = $subgridId; $i -le ($subGridLength + $subgridId - 1); $i++) {

                if($null -eq $subgridCollection[$i]){
                    $subgridCollection.Add($i, "")
                }  

                $subgridCollection[$i] += $shrink.Substring(0,3)
                $shrink = $shrink.Substring(3)

            }

            if($rowId -and $rowId % $subGridLength -eq 0){
                $subgridId = $subgridId + $subGridLength
            }
            
        } while ($shrink.Length -gt 0)

        [string[]]$output = @()
        $subgridCollection.GetEnumerator() | 
            Sort-Object -Property Name |
            ForEach-Object {
                $output += ,$_.value
            }

        return $output
    }


    hidden [array]makeNumberArray([int]$Length){
        $result = @()
        for ($i = 1; $i -lt $Length + 1; $i++) {
            [array]$result += $i

        }
        return $result
    }


    [void]checkSequence([string[]]$Sequences, [SequenceType]$SequenceType){
        
        [bool]$isValid = $true
        $targetDigits = $this.makeNumberArray($Sequences[0].Length)

        foreach($sequence in $Sequences){

            [array]$rowArray = @()
            $shrink = $sequence
            do {
                $rowArray += $shrink.Substring(0,1)
                $shrink = $shrink.Substring(1)
            } while ($shrink -gt 0)
            
            $comparison = Compare-Object $rowArray $targetDigits

            if($isValid){
                $isValid = ($null -eq $comparison) #Comparison returns $null if everything matches
            }

        }

        switch ($SequenceType){
            "rows" {$this.RowsAreValid = $isValid}
            "columns" {$this.ColumnsAreValid = $isValid}
            "subgrids" {$this.SubgridsAreValid = $isValid}
            default {$null}
        }
        
    }    
    
}


function Test-Sudoku{

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$Solution
    )

    begin{
        [SudokuGrid[]]$output = @()
    }

    process{
        Write-Verbose "Checking solution '$Solution'"

        $grid = [SudokuGrid]::new($Solution)
        $output += $grid

        $message = switch($grid.SolutionIsValid){
            $true {"Solution is correct"}
            $false {"Solution is wrong"}
        }
        Write-Verbose $message
    }

    end{
        return $output
    }

    
}


