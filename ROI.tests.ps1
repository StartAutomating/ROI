describe ROI {
    it 'Calculates Return on Investment' {        
        $roi = ROI -Cost 1 -Income 0.01 -Value 1
        # Becausing floating points and doubles "float", we need to round
        [Math]::Round($roi,2) | Should -Be 0.01
    }
    it 'Can calculate the gain of automation' {
        # Let's use this module as an example.        
        $roi = ROI -Cost (
            # Say a script takes 4 hours to write
            # and the author's time is worth 75/hour.        
            4 * 75
        ) -Income (
            # Now let's say saves any user 80% of the time to calculate ROI each time.
            # And let's presume they are paid the same
            # Let's say that was 5 minutes:
            (5/60 * 75 * .80) * # And let's presume users calculate that ROI 1500 times a year
                1500
        )
        # That's a 24x return on investment
        [Math]::Round($roi) | Should -Be 24
    }

    it 'Can pipe in values' {
        # Now let's calculate My ROI and everyone else's 
        # Let's assume:
        # * It takes each person 2 minutes to find this tool and install it
        # * There are 1kb people that find it
        # * Collectively, they calculate ROI 1mb times        
        $MyROI, $SomeonesROI, $EveryonesROI = 
            [PSCustomObject]@{
                Cost = 4 * 75
                Income = (5/60 * 75 * .80) * 1500 
            },
            [PSCustomObject]@{
                Cost = (2/60 * 75)
                Income = (5/60 * 75 * .80) * 1kb
            },
            [PSCustomObject]@{
                Cost = (2/60 * 75) * 1kb
                Income = (5/60 * 75 * .80) * 1mb 
            } |
                ROI
        
        $MyROI # My ROI is pretty small
        [Math]::Round($MyROI) | Should -Be 24

        $EveryonesROI # everyone's ROI is quite large
        [Math]::Round($EveryonesROI) | Should -Be 2047                    
    }
}
