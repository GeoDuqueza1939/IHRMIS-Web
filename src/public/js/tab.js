"use strict";

// import './elements.js';
// import { createElementEx, createSimpleElement, NO_NS } from './elements.js';

class TabControl {
    #parent = null;
    #tabs = [];
    #tabList = null;
    #selectedTabId = '';

    constructor(parentElement, ariaLabel = '') {
        this.#parent = parentElement;
        let tabPanels = Array.from(this.#parent.getElementsByClassName("tab-panel"));
        this.#tabList = createElementEx(NO_NS, 'div', this.#parent, tabPanels[0], 'class', 'tabs', 'role', 'tablist', 'aria-label', ariaLabel);

        tabPanels.forEach((tabPanel, i) => {
            let tab = Array.from(tabPanel.getElementsByClassName("tab"));

            if (tab.length === 0) {
                tab.push(createSimpleElement(NO_NS, 'div', 'tab', tabPanel));
                tab[0].innerHTML = "Tab " + i;
            }

            tabPanel.setAttribute('role', 'tabpanel');

            let tabPanelId = tabPanel.getAttribute('id');

            if (tabPanelId == null) {
                tabPanelId = 'tab-' + i;
                tabPanel.setAttribute('id', tabPanelId);
            }
            else if (!tabPanelId.startsWith('tab-')) {
                tabPanelId = 'tab-' + tabPanelId;
                tabPanel.setAttribute('id', tabPanelId);
            }

            tabPanel.setAttribute('aria-labelledby', tabPanelId.replace(/(tab)(-)/, '$1btn$2'));
            this.#tabs[tabPanelId] = {
                tab: tab[0],
                panel: tabPanel,
            };

            this.#tabList.append(tab[0]);

            tab[0].setAttribute('role', 'tab');
            tab[0].setAttribute('aria-tabfor', tabPanelId);

            tab[0].addEventListener('click', () => {
                this.activateTab(tabPanelId);
            });

            if (this.#selectedTabId === '') {
                this.#selectedTabId = tabPanelId;
                this.#tabs[tabPanelId].tab.classList.add('selected');
                this.#tabs[tabPanelId].panel.classList.add('selected');
            }
        });
    }

    activateTab(tabId) {
        let selected = this.#tabs[this.#selectedTabId]; 
        selected.tab.classList.remove('selected');
        selected.panel.classList.remove('selected');

        selected = this.#tabs[tabId];
        selected.tab.classList.add('selected');
        selected.panel.classList.add('selected');

        this.#selectedTabId = tabId;
    }
}
