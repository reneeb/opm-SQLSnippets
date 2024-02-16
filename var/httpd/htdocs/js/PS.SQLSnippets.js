// --
// Copyright (C) 2021 Perl-Services.de, http://perl-services.de
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var PS = PS || {};

/**
 * @namespace
 * @exports TargetNS as PS.Checklist
 * @description
 *      This namespace contains the special module functions for the customer search.
 */
PS.SQLSnippets = (function (TargetNS) {

    TargetNS.Init = function() {
        $('#SQLSnippets').on('change', function() {
            let SQLSnippets = Core.Config.Get( SQLSnippets ) || {};
            let SQLSnippet  = SQLSnippets[ $(this).val() ].SQL;

            $('#SQL').val( SQLSnippet );
        });

        $('#RunSave').on('click', function() {
            $('#SaveAsSnippet').val(1);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(PS.SQLSnippets || {}));
