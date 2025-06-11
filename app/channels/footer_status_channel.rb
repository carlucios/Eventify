# frozen_string_literal: true

# FooterStatusChannel é responsável por transmitir atualizações dinâmicas
# para o componente de status do rodapé, personalizado por usuário.
# Usa ActionCable (WebSocket) para comunicação em tempo real.
class FooterStatusChannel < ApplicationCable::Channel
  # Chamado quando o usuário se inscreve no canal via WebSocket
  def subscribed
    stream_for current_user
  end

  # Chamado automaticamente quando o usuário se desconecta ou sai da página
  def unsubscribed
    # Qualquer limpeza necessária ao desconectar o canal
  end
end
