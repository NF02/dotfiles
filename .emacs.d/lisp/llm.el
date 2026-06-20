;;; llm.el --- Configurazione GPTel + Ollama  -*- lexical-binding: t; -*-

(use-package gptel
  :ensure t
  :defer t
  :config
  (setq gptel-model 'qwen2.5-coder:1.5b
        gptel-backend (gptel-make-ollama "Ollama"
                         :host "localhost:11434"
                         :models '(qwen2.5-coder:1.5b)))
  :bind (("C-c g" . gptel-send)
         ("C-c M-g" . gptel-menu)))

(use-package gptel-agent
  :ensure t
  :after gptel
  :config
  (setq gptel-agent-default-agent 'programmer
        gptel-agent-programmer-default-model "qwen2.5-coder:1.5b"))

(provide 'llm)
