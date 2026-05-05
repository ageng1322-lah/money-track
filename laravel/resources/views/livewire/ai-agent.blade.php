<div x-data="{ isOpen: false }" 
     x-on:toggle-ai-agent.window="isOpen = !isOpen"
     class="fixed"
     style="top: 90px; right: 20px; z-index: 99999; pointer-events: none;">
    
    <!-- Chat Window -->
    <div x-show="isOpen" 
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0 transform -translate-y-4"
         x-transition:enter-end="opacity-100 transform translate-y-0"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100 transform translate-y-0"
         x-transition:leave-end="opacity-0 transform -translate-y-4"
         x-data="{ scroll: () => { $el.scrollTo(0, $el.scrollHeight); } }" 
         x-init="scroll(); $watch('messages', () => scroll())"
         style="width: 380px; height: 600px; background-color: #0F0F0F !important; border: 1px solid rgba(255,255,255,0.1); border-radius: 24px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); display: flex; flex-direction: column; overflow: hidden; pointer-events: auto; opacity: 1 !important;">
        
        <!-- Header -->
        <div style="padding: 20px; background-color: #059669; display: flex; align-items: center; justify-content: space-between;">
            <div style="display: flex; align-items: center; gap: 12px;">
                <div style="width: 40px; height: 40px; border-radius: 9999px; background-color: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;">
                    <svg style="width: 24px; height: 24px; color: white;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                </div>
                <div>
                    <h3 style="color: white; font-weight: bold; font-size: 14px; margin: 0;">AI Agent</h3>
                    <p style="color: #d1fae5; font-size: 10px; text-transform: uppercase; letter-spacing: 0.05em; margin: 0;">Smart Assistant</p>
                </div>
            </div>
            <button x-on:click="isOpen = false" style="background-color: rgba(255,255,255,0.1); border: none; padding: 8px; border-radius: 12px; cursor: pointer; color: white;">
                <svg style="width: 20px; height: 20px;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>

        <!-- Messages Area -->
        <div id="chat-messages" style="flex: 1; overflow-y: auto; padding: 20px; display: flex; flex-direction: column; gap: 16px; background-color: #0F0F0F !important;">
            @foreach($messages as $message)
                <div style="display: flex; justify-content: {{ $message['role'] === 'user' ? 'flex-end' : 'flex-start' }};">
                    <div style="max-width: 85%; padding: 12px 16px; border-radius: 16px; font-size: 14px; line-height: 1.5; 
                        {{ $message['role'] === 'user' 
                           ? 'background-color: #059669; color: white; border-top-right-radius: 0;' 
                           : 'background-color: rgba(255,255,255,0.05); color: #e5e7eb; border: 1px solid rgba(255,255,255,0.1); border-top-left-radius: 0;' 
                        }}">
                        {!! nl2br(e($message['content'])) !!}
                    </div>
                </div>
            @endforeach
            
            @if($isLoading)
                <div style="display: flex; justify-content: flex-start;">
                    <div style="background-color: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); padding: 12px 16px; border-radius: 16px; border-top-left-radius: 0;">
                        <div style="display: flex; gap: 4px;">
                            <div style="width: 8px; height: 8px; background-color: #10b981; border-radius: 9999px; animation: bounce 1s infinite;"></div>
                            <div style="width: 8px; height: 8px; background-color: #10b981; border-radius: 9999px; animation: bounce 1s infinite 0.1s;"></div>
                            <div style="width: 8px; height: 8px; background-color: #10b981; border-radius: 9999px; animation: bounce 1s infinite 0.2s;"></div>
                        </div>
                    </div>
                </div>
            @endif
        </div>

        <!-- Input Area -->
        <div style="padding: 20px; background-color: #0A0A0A; border-top: 1px solid rgba(255,255,255,0.1);">
            <form wire:submit.prevent="sendMessage" style="position: relative; display: flex; align-items: center;">
                <input wire:model="input" type="text" placeholder="Tulis pesan ke AI..." 
                       style="width: 100%; background-color: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 14px 50px 14px 16px; color: white; font-size: 14px; outline: none;">
                <button type="submit" style="position: absolute; right: 8px; background-color: #10b981; border: none; padding: 8px; border-radius: 12px; cursor: pointer; color: black; display: flex; align-items: center; justify-content: center;">
                    <svg style="width: 24px; height: 24px;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9-2-9-18-9 18 9 2zm0 0v-8" />
                    </svg>
                </button>
            </form>
            <p style="text-align: center; color: rgba(255,255,255,0.2); font-size: 9px; margin-top: 12px; letter-spacing: 0.1em; text-transform: uppercase;">Powered by Gemini AI</p>
        </div>
    </div>

    <style>
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-4px); }
        }
        #chat-messages::-webkit-scrollbar { display: none; }
        #chat-messages { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</div>
