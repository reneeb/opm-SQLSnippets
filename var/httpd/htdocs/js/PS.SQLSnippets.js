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
            console.debug( "Load SQL snippet" );
            console.debug( $(this).val() );

            let SQLSnippets    = Core.Config.Get( 'SQLSnippets' ) || {};
            let SQLSnippetData = SQLSnippets[ $(this).val() ];
            let SQLSnippet     = SQLSnippetData.SQL;
            let Name           = SQLSnippetData.SnippetName;

            console.debug( SQLSnippets );
            console.debug( SQLSnippet );

            $('#SQL').val( SQLSnippet );
            $('#SnippetName').val(Name);
        });

        $('#RunSave').on('click', function() {
            $('#SaveAsSnippet').val(1);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(PS.SQLSnippets || {}));
