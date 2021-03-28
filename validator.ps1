
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
    }


    [array]getRows($Solution){

        [array]$output = @()
        [string]$shrink = $Solution
        do {
            $output += $shrink.Substring(0,9)
            $shrink = $shrink.Substring(9)
            
        } while ($shrink.Length -gt 0)

        return $output

    }


    hidden [array]getNumberArray([int]$Length){
        $result = @()
        for ($i = 1; $i -lt $Length + 1; $i++) {
            [array]$result += $i

        }
        return $result
    }


    [void]checkSequence([string[]]$Sequences, [SequenceType]$SequenceType){
        
        [bool]$isValid = $true
        $targetDigits = $this.getNumberArray($Sequences[0].Length)

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


