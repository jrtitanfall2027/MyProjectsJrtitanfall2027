#include "hmg.ch"

REQUEST HB_RANDOM

FUNCTION GenerateRandomSalt(nLength)
    public cSalt := ""
    public i

    FOR i := 1 TO nLength
        cSalt += Chr(hb_RandomInt(33, 126)) // Caracteres imprimíveis ASCII
    NEXT
    //MsgStop(cSalt, "teste")
RETURN cSalt


declare window tela_login

Function tela_login_btnok_action

    local cUserName := ""
    local cPassword := ""
    local cUserCode := 0
    local cSalt := ""
    local cSalt1 := ""
    
    local lAdmin := .F.
    local lResult   := .F.
    local cCombined := ""
    local cHashCombined := ""
    local aItens    := {}
    
    cUserName := getProperty("tela_login","lblUsuario","value")
    cPassword := hb_SHA512(getProperty("tela_login","lblSenha","value"))
    
    cSalt := GenerateRandomSalt(16) // Gera um salt aleatório de 16 caracteres

    if ValidaUsuario(cUserName, cPassword, @cUserCode, @lAdmin, @cSalt1)
   
        pcUserLogin := cUserName
        pcUserCode  := cUserCode
        plAdmin     := lAdmin

        doMethod("tela_login","RELEASE")
    else
        MsgStop("Usuário/Senha incorreto!", "Identificação de Usuário")
        pnTry++
    end if

    if pnTry >= 3
        BloqueiaUsuario(cUserName)
        MsgStop("Quantidade de tentativas excedida! Usuário bloqueado! Contate o administrador do sistema!", "Identificação de Usuário")
        doMethod("tela_login","RELEASE")
    endif

Return NIL
    
