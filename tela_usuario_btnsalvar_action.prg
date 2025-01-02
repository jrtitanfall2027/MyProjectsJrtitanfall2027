#include "hmg.ch"

declare window tela_usuario

Function tela_usuario_btnsalvar_action

    local cBotaoAcao
    local cCodUsuario
    local cAcao         := "X"
    local aDados        := {}
    local aAcessos      := {}
    local nItens        := 0
    local nI            := 0
    local aAcesso       := {}
    local lResultado    := .F.
    local cHash         := ""
    local cSalt         := ""
    local cCombined     := ""
    local cHashCombined := ""
    local tbSenhaUsuario := ""
 
    cBotaoAcao  := getProperty("tela_usuario", "btnSalvar", "Caption")
    cCodUsuario := getProperty("tela_usuario", "tbCodigoUsuario", "Value")

    AAdd( aDados, getProperty("tela_usuario", "tbNomeUsuario", "Value"))                    // nome
    cHash:= hb_SHA512(getProperty("tela_usuario", "tbSenhaUsuario", "Value"))
    cSalt := GenerateRandomSalt(16) // Gera um salt aleatório de 16 caracteres
    cCombined := cSalt + cHash
    cHashCombined := Lower(hb_SHA512(cCombined))
    
    tbSenhaUsuario := cHashCombined
    AAdd( aDados, getProperty("tela_usuario", "tbSaltUsuario" , "Value" ))
    AAdd( aDados, getProperty("tela_usuario", "tbSenhaUsuario" , "Value" ))

    AAdd( aDados, iif( getProperty("tela_usuario", "cbAdministrador", "Value"), "S", "N" )) // admin
    AAdd( aDados, iif( getProperty("tela_usuario", "cbBloqueado", "Value"), "S", "N" ))     // bloqueado
    AAdd( aDados, iif( getProperty("tela_usuario", "cbExcluido", "Value"), "S", "N" ))      // excluido

    nItens := getProperty("tela_usuario", "gAcessosRotinas", "ItemCount")
    for nI := 1 to nItens
        aAcesso := getProperty("tela_usuario", "gAcessosRotinas", "Item", nI)
        AAdd( aAcessos, aAcesso )
    next

    if cBotaoAcao == "Excluir"
        cAcao := "E"
        lResultado := excluiUsuario( cCodUsuario )
    elseif cBotaoAcao == "Salvar"
        cAcao := iif(cCodUsuario == "", "I", "A")
        if cCodUsuario == ""
            lResultado := incluiUsuario( aDados, aAcessos, cSalt, cHashCombined )
        else
            lResultado := alteraUsuario( cCodUsuario, aDados, aAcessos, cSalt, cHashCombined )
        end if
    end if

    if lResultado
        doMethod("tela_usuario", "RELEASE")
    end if


Return Nil
