tableextension 50820 "WDC-ED Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(50810; "Professional Tax"; Option)
        {
            CaptionML = ENU = 'Professional Tax', FRA = 'Taxe professionnelle';
            OptionCaptionML = ENU = 'No Tax,Fixed Asset for more than 30 years 1,Fixed Asset for more than 30 years 2,Fixed Asset less than 30 years',
                              FRA = 'Pas de taxe,Immo. plus de 30 ans 1,Immo. plus de 30 ans 2,Immo. moins de 30 ans';
            OptionMembers = "No Tax","Fixed Asset for more than 30 years 1","Fixed Asset for more than 30 years 2","Fixed Asset less than 30 years";
        }

    }

}