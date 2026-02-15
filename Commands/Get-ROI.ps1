function Get-ROI
{
    <#
    .SYNOPSIS
        Gets Return on Investment
    .DESCRIPTION
        Gets the ROI or Return on Investment.
    .EXAMPLE
        # Get ROI on a dollar with 0.03 interest
        Get-ROI -Cost 1 -Income 0.03 -Value 1
    .EXAMPLE
        # Get ROI on an hour's automation
        # Let's presume 50 is the cost of writing a script        
        Get-ROI -Cost 50 -Income (            
            50 *      # We can view the income as the amount of time saved.
               0.95 * # Let's presume automation removes 95% of the time
               100    # and we would need to run it 100 times
        ) -Value 0    # Let's also presume this automation has no saleable value
        # In this simple case, the return on automation is 9400%
    .EXAMPLE
        # Now let's look at a real work scenario:
        ROI -Cost (
            # Let's say it took us 40 hours to make a migration tool.
            # It moves service accounts to group managed service accounts (GMSAs)
            # (this makes them more secure and avoids the need to rotate passwords)
            65 * 40
        ) -Value (            
            65 *       # Now let's say that it takes 
                0.98 * # And it saves 98% of the time to migrate accounts
                450    # and there are 450 accounts
            # While we might not have a saleable value
            # We can treat the time saved in migration as simple cost savings
        ) -Income (
            # Now let's say we're saving 100% of the time to rotate credentials.
            65 *     # Each credential would have taken an hour to rotate.
               4 *   # and would be rotated 4 times a year.               
               450 * # and we are saving that time for 450 accounts.
               8     # Last but not least, let's assume we'll use this for 8 years.
        )
        # This works out to:
        # * A cost of $2600
        # * A value of $28,665
        # * An income of $936,000
        # * A return of 37,002.5%
        # The ROI on automation can be quite spectacular
    .EXAMPLE
        # Let's use this module as an example.        
        $roi = ROI -Cost (
            # This took about 4 hours to write and document
            # and the author's time is generally worth at least $75/hour.
            4 * 75
        ) -Income (
            # Now let's say I save 80% of the time to calculate ROI                        
            # Let's say that was 5 minutes:
            (5/60 * 75 * .80) * 
                1500 # and guess that I use this 1500 times in my life.
        )
        # That's a 24x return on investment
        [Math]::Round($roi) | Should -Be 24
    .EXAMPLE
        # Now let's calculate My ROI and everyone else's 
        # Let's assume:
        # * It takes each person 2 minutes to find this tool and install it
        # * There are 1kb people that find it
        # * Collectively, they calculate ROI 1mb times
        # We can calculate My ROI, Someone's ROI, and Everyone's ROI
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

        # My ROI is small
        $myROI
        
        # Smaller than any user's ROI
        $myROI -lt $SomeonesROI
        
        # Their ROI is large
        $someonesROI        
        
        # The ROI to everyone is larger than my ROI
        $EveryonesROI -gt $myROI
        
        # Everyone's ROI is the same as the average user ROI
        $EveryonesROI                 
    .EXAMPLE
        # Now let us consider ROI for content creation
        # Let's say we make a video and it takes us 40 hours
        ROI -Cost (
            40 * 40
        ) -Income (
            # Let's say this earns us 100 a month for 12 months 
            100 * 12
        ) -Value 0 # and we cannot resell the video
        # Congratulations, this has a negative ROI of -25%.
    .EXAMPLE
        # Now let's consider ROI for content creation with automation or AI        
        ROI -Cost (
            40 * 4 + # We can make a similar video in 4 hours
            5 # But we have to pay 5 in token costs
        ) -Income (
            # Because it may be of lower quality, let's presume 75/month
            75 * 12 
        ) -Value 0 # and we cannot resell the video
        # Congratulations, this has a ROI of 445.45%!
        # For one-time tasks, automation and AI help a lot
    .EXAMPLE
        # Let's calculate ROI on software creation with AI
        # Let's imagine we have a simple software vibe coded in 8 hours
        ROI -Cost (
            65 * 8 + # That's 65*8 and then
                10 # 10 dollars of AI tokens
        ) -Income (
            # Let's assume we have 50 customers at 5 a month over 12 months
            (50 * 5 * 12) - (
                # Let's also assume we spend 6 hours each release refactoring
                # Five dollars of AI tokens each time
                # And a release every month
                ((65 * 6) - 5) * 12
            )
        )
        # Oh, dear, now we're losing -405.66%
    .EXAMPLE
        # Let's get more "real world"
        # Let's imagine we have a complex software vibe codeded in 40 hours
        # With an additional 40 hours of meetings
        ROI -Cost (
            (65 * 40 * 2) + 10
        ) -Income (
            # Now let's assume we have 500 customers at 5/month for a year
            (50 * 5 * 12) - (
                # We will assume each release takes 40 hours of meetings
                # and we will assume we have to vibe code from scratch each time
                ((65 * 40 * 2) + 10) * 12
            ) 
        )
        # Uh oh, we're not losing -1,242.42%, or -$59,520
        # I think the proof is clear: AI may not save money on recurring tasks
    .EXAMPLE
        # Let's add some randomization
        ROI -Cost (
            # Let's say it takes between 20 and 40 hours of vibe coding
            65 * (Get-Random -Min 20 -Max 40) + 
                # between 5 and 50 dollars of tokens
                (Get-Random -Min 5 -Max 50) +
            65 * (Get-Random -Min 20 -Max 40) # and between 20 and 40 hours of time
        ) -Income (
            # Now let's randomize our number of customers
            (
                (Get-Random -Min 5 -Max 500) * 5 * 12
            ) - (            
                    65 * (Get-Random -Min 20 -Max 40) + 
                        # between 5 and 50 dollars of tokens
                        (Get-Random -Min 5 -Max 50) +
                    65 * (Get-Random -Min 20 -Max 40) # and between 20 and 40 hours of time
            ) * 6
        )
        # In this scenario our ROI will swing wildly
        # And this is the point to understand.
    .EXAMPLE
        # Let's take our previous example to it's extremes to see the range
        ROI -Cost (
            # Let's say it takes 40 hours of vibe coding
            65 * 40 + 
                # 50 dollars of tokens
                50 +
            65 * 40 # 40 hours of meetings
        ) -Income (
            # and we have 5 customers
            (5 * 5 * 12) - (
                # and do six releases each year
                ((65 * 40) +50 + (65 * 40)) * 6
            )
        )
        # Ouch!  That's a -ROI of 694.29%, and a loss of $31,200.
    .EXAMPLE
        # Now let's be optimistic
        ROI -Cost (
            # Let's say it takes 20 hours of vibe coding
            65 * 20 + 
                # 5 dollars of tokens
                5 +
            65 * 20 # 20 hours of meetings
        ) -Income (
            # and we have 5 customers
            (500 * 5 * 12) - (
                # and do six releases each year
                ((65 * 20) +5 + (65 * 20)) * 6
            )
        )
        # In our optimistic scenario, with 100 times the customers
        # We have an ROI of 451.63%, and an income of $14,370.

        # This means recurring use of AI could lose us tens of thousands of dollars
        # and potentially earn us a smaller tens of thousands of dollars.
    .EXAMPLE
        # Now let's consider the ROI of PowerShell and building a useful platform for automation.
        ROI -Cost (
            100kb * # Our initial investment is a bit over $100kb a person 
                30 * # times 30 people
                3 # over 3 years 
        ) -Income (
            # Now let's say 10% of every dollar earned by Azure is due to automation
            # (real number probably much higher)
            # Azure is now a $75,000,000,000 a year business
            70gb * .1
        )
        # We've kept it simple and only measured the current year.
        # The original investment of Microsoft's time has a cost of
        # $9,216,000 (a little over nine million)
        # And it's value to just one part of Microsoft, over 19 years later, is:
        # $7,516,192,768 (about 7.5 _billion_)
        # Which works out to a _wonderful_ 81,455.91% ROI
        # For just one product.
        # In one company.
        # In just one year.
    #>
    [Alias('ROI','ReturnOnInvestment','Get-ReturnOnInvestment')]
    param(
    # The cost of the investment.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Q',
        'InitialInvestment',
        'CostOfGoodsSold',
        'Expenses',
        'Initial Investment', 
        'Cost Of Goods Sold'
    )]
    [double]
    $Cost = 0,

    # The recurring income from the investment.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('I',
        'Benefit',
        'NetIncome',
        'Net Income',
        'IncomeFromInvestment',
        'Income From Investment'
    )]
    [double]
    $Income = 0,

    # The current value of the investment.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('I0', 'CurrentValue','Revenue', 'Current Value')]
    [double]
    $Value = 0
    )

    process {
        # If we had a zero cost we will not be able to divide 
        $roi = if ($Cost -eq 0) {
            # but we can make a judgement on return.        

            # If the net value + income is greater than zero
            if ($Value + $Income -gt 0) {
                # it is an infinite positive return
                [double]::PositiveInfinity
            } 
            # If the value and income equal zero, it is zero
            elseif ($value + $Income -eq 0) {
                [double]0
            }
            # Otherwise, it is a negative infinite return.
            else {
                [double]::NegativeInfinity
            }        
        } else {
            ($Income + $Value - $Cost) / $cost
        }

        $roi = [PSObject]::new($roi)
        $roi.pstypenames.insert(0,'ReturnOnInvestment')
        $roi |    
            Add-Member NoteProperty 'Return' $roi -Force -PassThru |
            Add-Member NoteProperty Cost $cost -Force -PassThru |
            Add-Member NoteProperty Income $Income -Force -PassThru |
            Add-Member NoteProperty Value $Value -Force -PassThru
    }
}
