"use strict";

/**
 * SectionSwitcher — shared section navigation for the employee record views.
 *
 * Drives a list of section controls and a set of section panels: activating a
 * control shows the matching panel and keeps the shared header (title,
 * counter, pager) in sync. Supports arrow-key navigation, deep links and a
 * pager.
 *
 * The layout supplies the markup and, optionally, an onChange callback for
 * its own transition:
 *
 *   - controls:      role="tab" elements
 *   - panels:        role="tabpanel" elements
 *   - title:         [data-section-title]
 *   - counter:       [data-section-count]
 *   - previous:      [data-section-prev]
 *   - next:          [data-section-next]
 *
 * @author Geovani P. Duqueza
 * @version 1.00
 */
class SectionSwitcher {
    #root = null;
    #tabs = [];
    #panels = [];
    #selectedIndex = 0;
    #titleElement = null;
    #countElement = null;
    #prevElement = null;
    #nextElement = null;
    #onChange = null;

    /**
     * @param {Element} rootElement Container holding both the controls and the
     *        panels.
     * @param {Object} options
     *        tab    - selector for the section controls.
     *        panel  - selector for the section panels.
     *        onChange - called as (index, direction) after a section is
     *                    activated; direction is 1 (forward), -1 (backward) or
     *                    0 (initial).
     */
    constructor(rootElement, options = {}) {
        const selectors = Object.assign({
            tab: '[role="tab"]',
            panel: '[role="tabpanel"]',
        }, options);

        this.#root = rootElement;
        this.#onChange = options.onChange || null;
        this.#tabs = Array.from(rootElement.querySelectorAll(selectors.tab));
        this.#panels = Array.from(rootElement.querySelectorAll(selectors.panel));

        this.#titleElement = rootElement.querySelector('[data-section-title]');
        this.#countElement = rootElement.querySelector('[data-section-count]');
        this.#prevElement = rootElement.querySelector('[data-section-prev]');
        this.#nextElement = rootElement.querySelector('[data-section-next]');

        this.#tabs.forEach((tab, index) => {
            tab.addEventListener('click', () => this.activate(index, true));
        });

        this.#prevElement?.addEventListener('click', () => this.activate(this.#selectedIndex - 1, true));
        this.#nextElement?.addEventListener('click', () => this.activate(this.#selectedIndex + 1, true));

        this.#root.addEventListener('keydown', (event) => this.#onKeyDown(event));

        // honour a deep link such as .../emre/1#sec-education
        let start = 0;
        const hash = location.hash;
        if (hash) {
            const at = this.#panels.findIndex((panel) => '#' + panel.id === hash);
            if (at >= 0) {
                start = at;
            }
        }
        this.activate(start, false);
    }

    /**
     * Shows a section and updates the shared header.
     * @param {Number} index Zero-based section index.
     * @param {Boolean} pushHash Whether the location hash should follow.
     */
    activate(index, pushHash) {
        if (index < 0 || index >= this.#tabs.length) {
            return;
        }

        const direction = (index > this.#selectedIndex) ? 1 : (index < this.#selectedIndex ? -1 : 0);
        this.#selectedIndex = index;

        this.#tabs.forEach((tab, i) => {
            const selected = (i === index);
            tab.classList.toggle('selected', selected);
            tab.setAttribute('aria-selected', selected ? 'true' : 'false');
            tab.setAttribute('tabindex', selected ? '0' : '-1');
        });

        // the layout is told before the panels change, so that it can set up
        // its transition (which direction the incoming card slides from)
        if (this.#onChange) {
            this.#onChange(index, direction);
        }

        this.#panels.forEach((panel, i) => {
            panel.classList.toggle('selected', i === index);
        });

        if (this.#titleElement) {
            this.#titleElement.textContent = this.#tabs[index].textContent.trim();
        }
        if (this.#countElement) {
            this.#countElement.textContent = `${index + 1} of ${this.#tabs.length}`;
        }
        if (this.#prevElement) {
            this.#prevElement.disabled = (index === 0);
        }
        if (this.#nextElement) {
            this.#nextElement.disabled = (index === this.#tabs.length - 1);
        }

        const panel = this.#panels[index];
        if (pushHash && panel && panel.id) {
            try {
                history.replaceState(null, '', '#' + panel.id);
            } catch (e) {
                /* history is unavailable; the view still works */
            }
        }
    }

    // Private methods
    #onKeyDown(event) {
        const current = this.#tabs.indexOf(document.activeElement);
        if (current < 0) {
            return;
        }

        let next = null;
        if (event.key === 'ArrowDown' || event.key === 'ArrowRight') {
            next = (current + 1) % this.#tabs.length;
        } else if (event.key === 'ArrowUp' || event.key === 'ArrowLeft') {
            next = (current - 1 + this.#tabs.length) % this.#tabs.length;
        } else if (event.key === 'Home') {
            next = 0;
        } else if (event.key === 'End') {
            next = this.#tabs.length - 1;
        }

        if (next !== null) {
            event.preventDefault();
            this.#tabs[next].focus();
            this.activate(next, true);
        }
    }
}
