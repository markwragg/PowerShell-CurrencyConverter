function ConvertFrom-UnixTime {
    <#
    .SYNOPSIS
        Converts a unix timestamp to a datetime object.
    #>
    param(
        [parameter(ValueFromPipeline, Mandatory)]
        $UnixTime
    )
    begin {
        [datetime]$Origin = '1970-01-01 00:00:00'
    }
    process {
        $Origin.AddSeconds($UnixTime)
    }
}