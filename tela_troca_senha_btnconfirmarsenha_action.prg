#include "hmg.ch"

declare window tela_troca_senha

Function tela_troca_senha_btnconfirmarsenha_action

    local cSenhaAtual   := ""
    local cSenhaAtual1  := ""
    local cNovaSenha1   := ""
    local cNovaSenha2   := ""
    local cNovaSenha3   := ""
    local cNovaSenha4   := ""
    local aResultado    := {}
    local lResultado    := .F.
    local cCombined     := ""
    local cCombined1     := ""
    local cCombined2     := ""
    local cHashCombined := ""
    local cHashCombined1 := ""
    local cHashCombined2 := ""
    local cSalt1        := ""
    local cSalt2        := ""
    local cSenha1       := ""
    local cStoredHash   := ""
    local aDados     := {}
    
    cSenhaAtual1 := hb_SHA512(GetProperty("tela_troca_senha", "tbSenhaAtual", "Value"))
    
    cCombined      := pcSalt1 + cSenhaAtual1
    cHashCombined  := hb_SHA512(cCombined)
    
    cStoredHash    := cSenha1
    cSenhaAtual    := cHashCombined
    
    cNovaSenha1 := hb_SHA512(GetProperty("tela_troca_senha", "tbNovaSenha", "Value"))
    
    cSalt2 := GenerateRandomSalt(16) // Gera um salt aleatório de 16 caracteres
    cCombined1      := cSalt2 + cNovaSenha1
    cHashCombined1  := hb_SHA512(cCombined1)
    cNovaSenha3     := cHashCombined1
    
    cNovaSenha2 := hb_SHA512(GetProperty("tela_troca_senha", "tbNovaSenha2", "Value"))
    
    cCombined2      := cSalt2 + cNovaSenha2
    cHashCombined2  := Lower(hb_SHA512(cCombined2))
    cNovaSenha4     := cHashCombined2
    
    if ConectaBanco()
        // verifica se digitou a senha atual corretamente
        aResultado := leDadosUsuario(str(pcUserCode))
        
        if cSenhaAtual != aResultado[4]
            
            MsgStop("Senha atual digitada não corresponde à senha atual do usuário!", "Alteração de Senha")
        else
            // verificar se a segunda senha nova digitada é igual à primeira senha nova digitada
            if cNovaSenha3 == cNovaSenha4
                
                if MsgYesNo("Confirma alteração de senha?", "Alteração de Senha")

                    alteraSenha(cSalt2, cNovaSenha3)
                    
                end if
                lResultado := .T.
            else
                MsgStop("Segunda nova senha digitada não corresponde à primeira nova senha digitada!", "Alteração de Senha")
            end if
        end if

        MySQL_Destroy()
    end if

    if lResultado
        doMethod("tela_troca_senha", "RELEASE")
    end if


Return Nil
