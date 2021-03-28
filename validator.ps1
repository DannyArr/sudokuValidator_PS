
enum SequenceType{
    rows
    columns
    subgrids
}

class SudokuGrid {
    [array]$Rows
    [bool]$RowsAreValid
    [array]$Columns
    [array]$Subgrids


    SudokuGrid($Solution){
        $this.Rows = $this.getRows($Solution)
        $this.checkSequence($this.Rows, "rows")

        $this.Columns = $this.getColumns($Solution) #todo

        $this.SubGrids = $this.getSubgrids($Solution) #todo
    }


    [array]getRows($Solution){

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


    [array]getSubgrids($Solution){

        $stringLength = [math]::Sqrt($Solution.Length)
        $gridLength = [math]::Sqrt($stringLength)


        [string[]]$output = @(
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
            "subgrid" {$this.SubgridsAreValid = $isValid}
            default {$null}
        }
        
    }    
    
}


