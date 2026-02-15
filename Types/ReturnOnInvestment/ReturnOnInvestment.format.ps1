Write-FormatView -TypeName ReturnOnInvestment -Property 'Cost', 
    'Income', 'Value', 'Return' -AutoSize -FormatProperty @{
        'cost' = '{0:c}'
        'income' = '{0:c}'        
        'value' = '{0:c}'
        'return' = '{0:p}'
    }