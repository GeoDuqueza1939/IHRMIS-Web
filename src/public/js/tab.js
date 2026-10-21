"use strict";

// import './elements.js';
// import { createElementEx, createSimpleElement, NO_NS } from './elements.js';

class TabControl {
    #parent = null;
    #tabs = [];
    #tabList = null;
    #selectedTabId = '';
    #tabScrollBtn = [];

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

            let tabId = tabPanelId.replace(/(tab)(-)/, '$1btn$2');

            tabPanel.setAttribute('aria-labelledby', tabId);
            this.#tabs[tabPanelId] = {
                tab: tab[0],
                panel: tabPanel,
            };

            this.#tabList.append(tab[0]);

            tab[0].setAttribute('id', tabId);
            tab[0].setAttribute('role', 'tab');
            tab[0].setAttribute('aria-tabfor', tabPanelId);

            tab[0].addEventListener('click', () => {
                this.activateTab(tabPanelId);
            });

            if (this.#selectedTabId === '') {
                this.#selectedTabId = tabPanelId;
                Object.values(this.#tabs[tabPanelId]).forEach(el => el.classList.add('selected'));
            }
        });

        this.#setupTabScroll();
    }

    #setupTabScroll() {
        ["Left", "Right"].forEach((btnDirection, index) => {
            let btn = createElementEx(NO_NS, 'button', this.#tabList, null, 'class', `tab-scroll-btn-${btnDirection.toLowerCase()} hidden`, 'type', 'button', 'aria-label', `Scroll ${btnDirection}`);
            btn.innerHTML = `&#${9664 - index * 10};`
            btn.addEventListener('click', () => {
                this.#tabList.scrollBy({
                    left: (2 * index - 1) * 100,
                    behavior: 'smooth',
                });
            });
            this.#tabScrollBtn[btnDirection] = btn;
        });

        const observer = new ResizeObserver(entries => {
            for (let entry of entries) {
                Object.values(this.#tabScrollBtn).forEach(btn => {
                    btn.classList.toggle('hidden', entry.contentRect.width >= entry.target.scrollWidth);
                });
            }
        });

        observer.observe(this.#tabList);

        this.#tabList.addEventListener('mousewheel', event => {
            event.preventDefault();
            this.#tabList.scrollBy({
                left: event.deltaY,
                behavior: 'smooth',
            });
        });
    }

    activateTab(tabId) {
        [this.#tabs[this.#selectedTabId], this.#tabs[tabId]].forEach((tab, index) => {
            Object.values(tab).forEach(el => el.classList.toggle('selected', index === 1));
        });

        this.#selectedTabId = tabId;
    }
}
